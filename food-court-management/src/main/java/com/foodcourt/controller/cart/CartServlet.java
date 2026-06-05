package com.foodcourt.controller.cart;

import com.foodcourt.entity.Product;
import com.foodcourt.model.ShoppingCart;
import com.foodcourt.service.ProductService;
import com.foodcourt.service.impl.ProductServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private final ProductService productService = new ProductServiceImpl();
    private final Map<String, BigDecimal> couponMap = new HashMap<>();

    public CartServlet() {
        couponMap.put("FC10", new BigDecimal("10.00"));
        couponMap.put("NIGHT12", new BigDecimal("12.00"));
        couponMap.put("WELCOME5", new BigDecimal("5.00"));
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        if (session.getAttribute("user") == null) {
            session.setAttribute("error", "请先登录查看购物车！");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.getRequestDispatcher("/jsp/cart/view.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        
        // Check if user is logged in
        if (session.getAttribute("user") == null) {
            session.setAttribute("error", "请先登录后再添加到购物车！");
            String referer = req.getHeader("Referer");
            // Store the intended destination or referer if needed, but for now just redirect to login
            resp.sendRedirect(req.getContextPath() + "/login"); 
            return;
        }

        ShoppingCart cart = (ShoppingCart) session.getAttribute("cart");
        if (cart == null) {
            cart = new ShoppingCart();
            session.setAttribute("cart", cart);
        }

        String action = req.getParameter("action");
        try {
            if ("add".equals(action)) {
                int productId = Integer.parseInt(req.getParameter("productId"));
                Optional<Product> product = productService.getProductById(productId);
                if (product.isPresent()) {
                    cart.addItem(product.get(), 1);
                    session.setAttribute("message", "已成功加入购物车！");
                }
                adjustDiscount(session, cart);
                // Redirect back to referer or stall detail
                String referer = req.getHeader("Referer");
                resp.sendRedirect(referer != null ? referer : req.getContextPath() + "/cart");
            } else if ("update".equals(action)) {
                int productId = Integer.parseInt(req.getParameter("productId"));
                int quantity = Integer.parseInt(req.getParameter("quantity"));
                cart.updateQuantity(productId, quantity);
                adjustDiscount(session, cart);
                resp.sendRedirect(req.getContextPath() + "/cart");
            } else if ("remove".equals(action)) {
                int productId = Integer.parseInt(req.getParameter("productId"));
                cart.removeItem(productId);
                adjustDiscount(session, cart);
                resp.sendRedirect(req.getContextPath() + "/cart");
            } else if ("clear".equals(action)) {
                cart.clear();
                session.removeAttribute("cartDiscount");
                session.removeAttribute("cartCoupon");
                resp.sendRedirect(req.getContextPath() + "/cart");
            } else if ("applyCoupon".equals(action)) {
                String code = req.getParameter("couponCode");
                if (code != null) {
                    code = code.trim().toUpperCase();
                }
                BigDecimal discount = code == null ? null : couponMap.get(code);
                BigDecimal cartTotal = cart.getTotalAmount();

                if (discount == null) {
                    session.setAttribute("error", "优惠券无效或已过期");
                    session.removeAttribute("cartDiscount");
                    session.removeAttribute("cartCoupon");
                } else if (cartTotal.compareTo(BigDecimal.ZERO) <= 0) {
                    session.setAttribute("error", "购物车为空，无法使用优惠券");
                    session.removeAttribute("cartDiscount");
                    session.removeAttribute("cartCoupon");
                } else {
                    if (discount.compareTo(cartTotal) > 0) {
                        discount = cartTotal;
                    }
                    session.setAttribute("cartDiscount", discount);
                    session.setAttribute("cartCoupon", code);
                    session.setAttribute("message", "优惠券已使用");
                }
                resp.sendRedirect(req.getContextPath() + "/cart");
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/cart");
        }
    }

    private void adjustDiscount(HttpSession session, ShoppingCart cart) {
        Object discountObj = session.getAttribute("cartDiscount");
        if (discountObj instanceof BigDecimal) {
            BigDecimal discount = (BigDecimal) discountObj;
            BigDecimal cartTotal = cart.getTotalAmount();
            if (cartTotal.compareTo(BigDecimal.ZERO) <= 0) {
                session.removeAttribute("cartDiscount");
                session.removeAttribute("cartCoupon");
            } else if (discount.compareTo(cartTotal) > 0) {
                session.setAttribute("cartDiscount", cartTotal);
            }
        }
    }
}
