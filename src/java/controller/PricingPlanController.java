package controller;

import dao.PricingPlanDAO;
import models.PricingPlan;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;

public class PricingPlanController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String role = (String) session.getAttribute("role");
        if (!"Staff".equals(role) && !"Admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/customer-bikes");
            return;
        }
        
        String action = request.getParameter("action");
        PricingPlanDAO planDAO = new PricingPlanDAO();

        if ("list".equals(action) || action == null) {
            String keyword = request.getParameter("keyword");
            if (keyword != null && !keyword.trim().isEmpty()) {
                request.setAttribute("plans", planDAO.searchPlans(keyword));
                request.setAttribute("searchKeyword", keyword);
            } else {
                request.setAttribute("plans", planDAO.getAllPlans());
            }
            if ("Staff".equals(role)) {
                request.getRequestDispatcher("/staff/pricing-plans.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/admin/pricing-plans.jsp").forward(request, response);
            }
        } else if ("add".equals(action)) {
            if ("Staff".equals(role)) {
                request.getRequestDispatcher("/staff/pricing-plan-add.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/admin/pricing-plan-add.jsp").forward(request, response);
            }
        } else if ("edit".equals(action)) {
            int planID = Integer.parseInt(request.getParameter("id"));
            request.setAttribute("plan", planDAO.getPlanById(planID));
            if ("Staff".equals(role)) {
                request.getRequestDispatcher("/staff/pricing-plan-edit.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/admin/pricing-plan-edit.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String role = (String) session.getAttribute("role");
        if (!"Staff".equals(role) && !"Admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/customer-bikes");
            return;
        }
        
        String action = request.getParameter("action");
        PricingPlanDAO planDAO = new PricingPlanDAO();
        String basePath = "Staff".equals(role) ? "/staff/pricing-plan" : "/admin/pricing-plan";

        if ("add".equals(action)) {
            PricingPlan plan = new PricingPlan();
            plan.setPlanName(request.getParameter("planName"));
            plan.setUnlockFee(new BigDecimal(request.getParameter("unlockFee")));
            plan.setPricePerMin(new BigDecimal(request.getParameter("pricePerMin")));
            plan.setFreeMinutes(Integer.parseInt(request.getParameter("freeMinutes")));
            String dailyCapStr = request.getParameter("dailyCap");
            if (dailyCapStr != null && !dailyCapStr.isEmpty()) {
                plan.setDailyCap(new BigDecimal(dailyCapStr));
            }
            plan.setIsActive(Boolean.parseBoolean(request.getParameter("isActive")));

            if (planDAO.addPlan(plan)) {
                response.sendRedirect(request.getContextPath() + basePath + "?action=list");
            } else {
                request.setAttribute("error", "Thêm gói giá thất bại!");
                if ("Staff".equals(role)) {
                    request.getRequestDispatcher("/staff/pricing-plan-add.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("/admin/pricing-plan-add.jsp").forward(request, response);
                }
            }
        } else if ("update".equals(action)) {
            PricingPlan plan = new PricingPlan();
            plan.setPlanID(Integer.parseInt(request.getParameter("planID")));
            plan.setPlanName(request.getParameter("planName"));
            plan.setUnlockFee(new BigDecimal(request.getParameter("unlockFee")));
            plan.setPricePerMin(new BigDecimal(request.getParameter("pricePerMin")));
            plan.setFreeMinutes(Integer.parseInt(request.getParameter("freeMinutes")));
            String dailyCapStr = request.getParameter("dailyCap");
            if (dailyCapStr != null && !dailyCapStr.isEmpty()) {
                plan.setDailyCap(new BigDecimal(dailyCapStr));
            } else {
                plan.setDailyCap(null);
            }
            plan.setIsActive(Boolean.parseBoolean(request.getParameter("isActive")));

            if (planDAO.updatePlan(plan)) {
                response.sendRedirect(request.getContextPath() + basePath + "?action=list");
            } else {
                request.setAttribute("error", "Cập nhật gói giá thất bại!");
                int planID = Integer.parseInt(request.getParameter("planID"));
                request.setAttribute("plan", planDAO.getPlanById(planID));
                if ("Staff".equals(role)) {
                    request.getRequestDispatcher("/staff/pricing-plan-edit.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("/admin/pricing-plan-edit.jsp").forward(request, response);
                }
            }
        } else if ("delete".equals(action)) {
            int planID = Integer.parseInt(request.getParameter("planID"));
            if (planDAO.deletePlan(planID)) {
                response.sendRedirect(request.getContextPath() + basePath + "?action=list");
            } else {
                request.setAttribute("error", "Xóa gói giá thất bại!");
                request.setAttribute("plans", planDAO.getAllPlans());
                if ("Staff".equals(role)) {
                    request.getRequestDispatcher("/staff/pricing-plans.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("/admin/pricing-plans.jsp").forward(request, response);
                }
            }
        }
    }
}

