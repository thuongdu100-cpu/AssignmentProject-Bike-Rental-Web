package controller;

import dao.BikeModelDAO;
import models.BikeModel;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;

public class BikeModelController extends HttpServlet {

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
        BikeModelDAO modelDAO = new BikeModelDAO();

        if ("list".equals(action) || action == null) {
            String keyword = request.getParameter("keyword");
            if (keyword != null && !keyword.trim().isEmpty()) {
                request.setAttribute("models", modelDAO.searchModels(keyword));
                request.setAttribute("searchKeyword", keyword);
            } else {
                request.setAttribute("models", modelDAO.getAllModels());
            }
            request.getRequestDispatcher("/staff/bike-models.jsp").forward(request, response);
        } else if ("add".equals(action)) {
            request.getRequestDispatcher("/staff/bike-model-add.jsp").forward(request, response);
        } else if ("edit".equals(action)) {
            int modelID = Integer.parseInt(request.getParameter("id"));
            request.setAttribute("model", modelDAO.getModelById(modelID));
            request.getRequestDispatcher("/staff/bike-model-edit.jsp").forward(request, response);
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
        BikeModelDAO modelDAO = new BikeModelDAO();

        if ("add".equals(action)) {
            BikeModel model = new BikeModel();
            model.setModelName(request.getParameter("modelName"));
            model.setBrand(request.getParameter("brand"));
            model.setTypeName(request.getParameter("typeName"));
            String weightStr = request.getParameter("weightKg");
            if (weightStr != null && !weightStr.isEmpty()) {
                model.setWeightKg(new BigDecimal(weightStr));
            }
            model.setHasBattery(Boolean.parseBoolean(request.getParameter("hasBattery")));

            if (modelDAO.addModel(model)) {
                response.sendRedirect(request.getContextPath() + "/staff/bike-model?action=list");
            } else {
                request.setAttribute("error", "Thêm model thất bại!");
                request.getRequestDispatcher("/staff/bike-model-add.jsp").forward(request, response);
            }
        } else if ("update".equals(action)) {
            BikeModel model = new BikeModel();
            model.setModelID(Integer.parseInt(request.getParameter("modelID")));
            model.setModelName(request.getParameter("modelName"));
            model.setBrand(request.getParameter("brand"));
            model.setTypeName(request.getParameter("typeName"));
            String weightStr = request.getParameter("weightKg");
            if (weightStr != null && !weightStr.isEmpty()) {
                model.setWeightKg(new BigDecimal(weightStr));
            } else {
                model.setWeightKg(null);
            }
            model.setHasBattery(Boolean.parseBoolean(request.getParameter("hasBattery")));

            if (modelDAO.updateModel(model)) {
                response.sendRedirect(request.getContextPath() + "/staff/bike-model?action=list");
            } else {
                request.setAttribute("error", "Cập nhật model thất bại!");
                int modelID = Integer.parseInt(request.getParameter("modelID"));
                request.setAttribute("model", modelDAO.getModelById(modelID));
                request.getRequestDispatcher("/staff/bike-model-edit.jsp").forward(request, response);
            }
        } else if ("delete".equals(action)) {
            int modelID = Integer.parseInt(request.getParameter("modelID"));
            if (modelDAO.deleteModel(modelID)) {
                response.sendRedirect(request.getContextPath() + "/staff/bike-model?action=list");
            } else {
                request.setAttribute("error", "Xóa model thất bại!");
                request.setAttribute("models", modelDAO.getAllModels());
                request.getRequestDispatcher("/staff/bike-models.jsp").forward(request, response);
            }
        }
    }
}

