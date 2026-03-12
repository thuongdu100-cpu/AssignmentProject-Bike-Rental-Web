package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.vnpay.common.Config;
import dao.PaymentDAO;
import dao.RentalDAO;
import dao.BikeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import models.Payment;
import models.Rental;

public class PaymentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            // Tạo payment URL
            String rentalIDStr = request.getParameter("rentalID");
            if (rentalIDStr == null || rentalIDStr.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing rentalID");
                return;
            }
            
            long rentalID = Long.parseLong(rentalIDStr);
            RentalDAO rentalDAO = new RentalDAO();
            Rental rental = rentalDAO.getRentalById(rentalID);
            
            if (rental == null || rental.getCostAmount() == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid rental or no cost amount");
                return;
            }
            
            // Kiểm tra xem đã có payment chưa
            PaymentDAO paymentDAO = new PaymentDAO();
            Payment existingPayment = paymentDAO.getPaymentByRentalId(rentalID);
            if (existingPayment != null && "success".equals(existingPayment.getStatus())) {
                // Đã thanh toán rồi
                response.sendRedirect(request.getContextPath() + "/rental?action=list");
                return;
            }
            
            // Tạo payment record với status pending trước
            String vnp_TxnRef = Config.getRandomNumber(8);
            if (existingPayment == null) {
                Payment payment = new Payment();
                payment.setRentalID(rentalID);
                payment.setAmount(rental.getCostAmount());
                payment.setCurrency("VND");
                payment.setMethod("ewallet"); // Database chỉ cho phép 'cash', 'card', 'ewallet'
                payment.setStatus("pending");
                payment.setTransactionRef(vnp_TxnRef);
                paymentDAO.createPayment(payment);
            } else {
                vnp_TxnRef = existingPayment.getTransactionRef();
            }
            
            // Tạo payment URL với vnp_TxnRef đã có
            String paymentUrl = createPaymentUrl(rental, request, vnp_TxnRef);
            
            // Redirect to VNPay
            response.sendRedirect(paymentUrl);
            
        } else if ("vnpay-return".equals(action)) {
            // Xử lý return từ VNPay
            handleVnpayReturn(request, response);
        } else if ("vnpay-ipn".equals(action)) {
            // Xử lý IPN từ VNPay
            handleVnpayIpn(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private String createPaymentUrl(Rental rental, HttpServletRequest request, String vnp_TxnRef) throws ServletException, UnsupportedEncodingException {
        String vnp_Version = "2.1.0";
        String vnp_Command = "pay";
        // Dùng "other" theo code mẫu ajaxServlet.java
        String orderType = "other";
        // VNPay tính bằng xu, cần nhân với 100
        long amount = rental.getCostAmount().longValue() * 100;
        
        // Lấy IP address từ request, nếu không có thì dùng localhost
        String vnp_IpAddr = Config.getIpAddress(request);
        if (vnp_IpAddr == null || vnp_IpAddr.isEmpty() || vnp_IpAddr.startsWith("Invalid")) {
            vnp_IpAddr = "127.0.0.1";
        }
        String vnp_TmnCode = Config.vnp_TmnCode;
        
        // Kiểm tra TMN Code và Secret Key
        if (vnp_TmnCode == null || vnp_TmnCode.isEmpty() || Config.secretKey == null || Config.secretKey.isEmpty()) {
            throw new ServletException("VNPay configuration is missing. Please check Config.java");
        }
        
        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", vnp_Version);
        vnp_Params.put("vnp_Command", vnp_Command);
        vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", "VND");
        
        // KHÔNG truyền vnp_BankCode nếu rỗng (theo code mẫu)
        String bankCode = request.getParameter("bankCode");
        if (bankCode != null && !bankCode.isEmpty()) {
            vnp_Params.put("vnp_BankCode", bankCode);
        }
        
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        // vnp_OrderInfo: format đơn giản, không có ký tự đặc biệt
        String orderInfo = "Thanh toan don hang:" + vnp_TxnRef;
        // Giới hạn độ dài
        if (orderInfo.length() > 255) {
            orderInfo = orderInfo.substring(0, 255);
        }
        vnp_Params.put("vnp_OrderInfo", orderInfo);
        vnp_Params.put("vnp_OrderType", orderType);

        String locate = request.getParameter("language");
        if (locate != null && !locate.isEmpty()) {
            vnp_Params.put("vnp_Locale", locate);
        } else {
            vnp_Params.put("vnp_Locale", "vn");
        }
        // Sử dụng ReturnUrl từ Config, đảm bảo đúng format
        String returnUrl = Config.vnp_ReturnUrl;
        if (returnUrl == null || returnUrl.isEmpty()) {
            returnUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() 
                    + request.getContextPath() + "/payment?action=vnpay-return";
        }
        vnp_Params.put("vnp_ReturnUrl", returnUrl);
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
        
        // Dùng 15 phút theo code mẫu ajaxServlet.java
        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);
        
        List fieldNames = new ArrayList(vnp_Params.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        Iterator itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = (String) itr.next();
            String fieldValue = (String) vnp_Params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                //Build hash data - encode fieldValue (theo code mẫu)
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                //Build query - encode cả fieldName và fieldValue
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                if (itr.hasNext()) {
                    query.append('&');
                    hashData.append('&');
                }
            }
        }
        String queryUrl = query.toString();
        // Tính SecureHash từ hashData (đã encode fieldValue)
        String hashDataString = hashData.toString();
        String vnp_SecureHash = Config.hmacSHA512(Config.secretKey, hashDataString);
        
        // Debug: In ra các thông tin để kiểm tra
        System.out.println("=== VNPay Payment URL Debug ===");
        System.out.println("TMN Code: " + vnp_TmnCode);
        System.out.println("Secret Key: " + (Config.secretKey != null ? Config.secretKey.substring(0, Math.min(10, Config.secretKey.length())) + "..." : "NULL"));
        System.out.println("Return URL: " + returnUrl);
        System.out.println("IPN URL (từ Config): " + Config.vnp_IpnUrl);
        System.out.println("Amount: " + amount + " (xu) = " + (amount / 100) + " VND");
        System.out.println("TxnRef: " + vnp_TxnRef);
        System.out.println("HashData: " + hashDataString);
        System.out.println("SecureHash: " + vnp_SecureHash);
        System.out.println("================================");
        System.out.println("⚠️  LƯU Ý: Nếu gặp lỗi Code 76, hãy đăng ký IPN URL trong Merchant Admin!");
        System.out.println("   IPN URL: " + Config.vnp_IpnUrl);
        System.out.println("   Merchant Admin: https://sandbox.vnpayment.vn/merchantv2/");
        System.out.println("================================");
        
        queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
        String paymentUrl = Config.vnp_PayUrl + "?" + queryUrl;
        
        // Debug: In ra payment URL (có thể comment lại sau)
        System.out.println("Payment URL: " + paymentUrl);
        
        return paymentUrl;
    }

    private void handleVnpayReturn(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy tất cả parameters từ request và ENCODE fieldValue (giống như khi tạo payment URL)
        // CHỈ lấy các field bắt đầu với "vnp_" (loại bỏ "action" và các field khác)
        // Khi tạo payment URL: hashData = fieldName=encodedFieldValue
        // Khi verify return: cần encode lại fieldValue để khớp với hashData khi tạo payment URL
        Map fields = new HashMap();
        for (var params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = (String) params.nextElement();
            // CHỈ lấy các field bắt đầu với "vnp_" (loại bỏ "action" và các field khác)
            if (fieldName.startsWith("vnp_")) {
                String fieldValue = request.getParameter(fieldName);
                if (fieldValue != null && fieldValue.length() > 0) {
                    // Encode fieldValue (giống như khi tạo payment URL)
                    String encodedFieldValue = URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString());
                    fields.put(fieldName, encodedFieldValue);
                }
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        if (fields.containsKey("vnp_SecureHashType")) {
            fields.remove("vnp_SecureHashType");
        }
        if (fields.containsKey("vnp_SecureHash")) {
            fields.remove("vnp_SecureHash");
        }
        // Tính hashData string để debug (giống như khi tạo payment URL)
        List fieldNames = new ArrayList(fields.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashDataDebug = new StringBuilder();
        Iterator itrDebug = fieldNames.iterator();
        while (itrDebug.hasNext()) {
            String fieldName = (String) itrDebug.next();
            String fieldValue = (String) fields.get(fieldName);
            if (fieldValue != null && fieldValue.length() > 0) {
                hashDataDebug.append(fieldName);
                hashDataDebug.append('=');
                hashDataDebug.append(fieldValue);
                if (itrDebug.hasNext()) {
                    hashDataDebug.append('&');
                }
            }
        }
        
        // hashAllFields sẽ tính hash từ các field không encode (fieldName=fieldValue)
        String signValue = Config.hashAllFields(fields);
        
        // Debug: In ra để kiểm tra
        System.out.println("VNPay Return - Fields count: " + fields.size());
        System.out.println("VNPay Return - HashData string: " + hashDataDebug.toString());
        // In ra một vài field để debug
        if (fields.containsKey("vnp_TxnRef")) {
            System.out.println("VNPay Return - vnp_TxnRef: " + fields.get("vnp_TxnRef"));
        }
        if (fields.containsKey("vnp_Amount")) {
            System.out.println("VNPay Return - vnp_Amount: " + fields.get("vnp_Amount"));
        }
        System.out.println("VNPay Return - SignValue: " + signValue);
        System.out.println("VNPay Return - vnp_SecureHash: " + vnp_SecureHash);
        System.out.println("VNPay Return - Match: " + signValue.equals(vnp_SecureHash));

        String vnp_TxnRef = request.getParameter("vnp_TxnRef");
        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        String vnp_TransactionStatus = request.getParameter("vnp_TransactionStatus");
        String vnp_Amount = request.getParameter("vnp_Amount");
        String vnp_TransactionNo = request.getParameter("vnp_TransactionNo");
        String vnp_BankCode = request.getParameter("vnp_BankCode");

        // Tìm payment theo transactionRef
        PaymentDAO paymentDAO = new PaymentDAO();
        Payment payment = paymentDAO.getPaymentByTransactionRef(vnp_TxnRef);
        
        // Lấy rental details với đầy đủ thông tin (bike, user, station, plan)
        Rental rental = null;
        if (payment != null) {
            RentalDAO rentalDAO = new RentalDAO();
            rental = rentalDAO.getRentalById(payment.getRentalID());
            
            // Lấy thông tin bike đầy đủ (model, image)
            if (rental != null && rental.getBike() != null) {
                BikeDAO bikeDAO = new BikeDAO();
                models.Bike fullBike = bikeDAO.getBikeById(rental.getBikeID());
                if (fullBike != null) {
                    rental.setBike(fullBike);
                }
            }
        }
        
        boolean isValid = signValue.equals(vnp_SecureHash);
        boolean isSuccess = false;
        String errorMessage = null;
        
        if (isValid && payment != null) {
            // Kiểm tra ResponseCode và TransactionStatus
            // ResponseCode: 00 = thành công, khác 00 = lỗi
            // TransactionStatus: 00 = thành công, 02 = lỗi, khác = các trạng thái khác
            if ("00".equals(vnp_ResponseCode) && "00".equals(vnp_TransactionStatus)) {
                // Thanh toán thành công - Redirect đến trang invoice
                isSuccess = true;
                paymentDAO.updatePaymentByTransactionRef(vnp_TxnRef, "paid", vnp_TransactionNo);
                
                // Redirect đến trang invoice
                response.sendRedirect(request.getContextPath() + "/rental?action=invoice&rentalID=" + payment.getRentalID());
                return;
            } else {
                // Thanh toán không thành công
                isSuccess = false;
                paymentDAO.updatePaymentByTransactionRef(vnp_TxnRef, "failed", vnp_TransactionNo);
                
                // Xác định thông báo lỗi
                if ("02".equals(vnp_TransactionStatus)) {
                    errorMessage = "Giao dịch không thành công. Ngân hàng không hỗ trợ website này (Code 76).";
                } else if (vnp_ResponseCode != null && !vnp_ResponseCode.equals("00")) {
                    errorMessage = "Mã lỗi: " + vnp_ResponseCode;
                } else {
                    errorMessage = "Giao dịch không thành công. Mã trạng thái: " + vnp_TransactionStatus;
                }
            }
        } else if (!isValid) {
            errorMessage = "Lỗi xác thực chữ ký. Không thể xác minh giao dịch.";
        } else if (payment == null) {
            errorMessage = "Không tìm thấy thông tin giao dịch.";
        }
        
        request.setAttribute("vnp_TxnRef", vnp_TxnRef);
        request.setAttribute("vnp_ResponseCode", vnp_ResponseCode != null ? vnp_ResponseCode : "");
        request.setAttribute("vnp_TransactionStatus", vnp_TransactionStatus != null ? vnp_TransactionStatus : "");
        request.setAttribute("vnp_Amount", vnp_Amount);
        request.setAttribute("vnp_TransactionNo", vnp_TransactionNo != null ? vnp_TransactionNo : "");
        request.setAttribute("vnp_BankCode", vnp_BankCode);
        request.setAttribute("signValue", signValue);
        request.setAttribute("vnp_SecureHash", vnp_SecureHash);
        request.setAttribute("isValid", isValid);
        request.setAttribute("isSuccess", isSuccess);
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("payment", payment);
        request.setAttribute("rental", rental);

        request.getRequestDispatcher("/customer/payment-result.jsp").forward(request, response);
    }

    private void handleVnpayIpn(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Lấy tất cả parameters từ request (KHÔNG encode ở đây, để hashAllFields xử lý)
        Map fields = new HashMap();
        for (var params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = (String) params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                fields.put(fieldName, fieldValue);
            }
        }
        
        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        if (fields.containsKey("vnp_SecureHashType")) {
            fields.remove("vnp_SecureHashType");
        }
        if (fields.containsKey("vnp_SecureHash")) {
            fields.remove("vnp_SecureHash");
        }
        // hashAllFields sẽ tự xử lý encoding
        String signValue = Config.hashAllFields(fields);
        
        PrintWriter out = response.getWriter();
        JsonObject json = new JsonObject();
        
        if (signValue.equals(vnp_SecureHash)) {
            String vnp_TxnRef = request.getParameter("vnp_TxnRef");
            String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
            String vnp_TransactionStatus = request.getParameter("vnp_TransactionStatus");
            String vnp_Amount = request.getParameter("vnp_Amount");
            String vnp_TransactionNo = request.getParameter("vnp_TransactionNo");
            
            // Tìm payment theo transactionRef
            PaymentDAO paymentDAO = new PaymentDAO();
            Payment payment = paymentDAO.getPaymentByTransactionRef(vnp_TxnRef);
            
            if (payment != null) {
                // Kiểm tra số tiền
                // payment.getAmount() là số tiền VND (chưa nhân 100)
                // vnp_Amount từ VNPay là số tiền ở đơn vị "xu" (đã nhân 100)
                // Cần nhân expectedAmount lên 100 để so sánh
                long expectedAmount = payment.getAmount().longValue() * 100;
                long receivedAmount = Long.parseLong(vnp_Amount);
                
                if (expectedAmount == receivedAmount) {
                    // Kiểm tra trạng thái hiện tại
                    if ("pending".equals(payment.getStatus())) {
                        if ("00".equals(vnp_ResponseCode) && "00".equals(vnp_TransactionStatus)) {
                            // Thanh toán thành công
                            paymentDAO.updatePaymentByTransactionRef(vnp_TxnRef, "success", vnp_TransactionNo);
                            json.addProperty("RspCode", "00");
                            json.addProperty("Message", "Confirm Success");
                        } else {
                            // Thanh toán không thành công
                            paymentDAO.updatePaymentByTransactionRef(vnp_TxnRef, "failed", vnp_TransactionNo);
                            json.addProperty("RspCode", "00");
                            json.addProperty("Message", "Confirm Success");
                        }
                    } else {
                        // Đã được xử lý trước đó
                        json.addProperty("RspCode", "02");
                        json.addProperty("Message", "Order already confirmed");
                    }
                } else {
                    // Số tiền không khớp
                    json.addProperty("RspCode", "04");
                    json.addProperty("Message", "Invalid Amount");
                }
            } else {
                // Không tìm thấy payment
                json.addProperty("RspCode", "01");
                json.addProperty("Message", "Order not Found");
            }
        } else {
            json.addProperty("RspCode", "97");
            json.addProperty("Message", "Invalid Checksum");
        }
        
        out.print(json.toString());
        out.flush();
    }
}

