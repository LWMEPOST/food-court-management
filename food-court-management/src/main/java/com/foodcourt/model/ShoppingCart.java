package com.foodcourt.model;

import com.foodcourt.entity.Product;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ShoppingCart {
    private final Map<Integer, CartItem> items = new HashMap<>();

    public void addItem(Product product, int quantity) {
        CartItem item = items.get(product.getId());
        if (item == null) {
            item = new CartItem(product, quantity);
            items.put(product.getId(), item);
        } else {
            item.setQuantity(item.getQuantity() + quantity);
        }
    }

    public void updateQuantity(int productId, int quantity) {
        if (quantity <= 0) {
            items.remove(productId);
        } else {
            CartItem item = items.get(productId);
            if (item != null) {
                item.setQuantity(quantity);
            }
        }
    }

    public void removeItem(int productId) {
        items.remove(productId);
    }

    public void clear() {
        items.clear();
    }

    public List<CartItem> getItems() {
        return new ArrayList<>(items.values());
    }

    public BigDecimal getTotalAmount() {
        return items.values().stream()
                .map(CartItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public static class CartItem {
        private final Product product;
        private int quantity;

        public CartItem(Product product, int quantity) {
            this.product = product;
            this.quantity = quantity;
        }

        public Product getProduct() { return product; }
        public int getQuantity() { return quantity; }
        public void setQuantity(int quantity) { this.quantity = quantity; }
        
        public BigDecimal getSubtotal() {
            return product.getPrice().multiply(new BigDecimal(quantity));
        }
    }
}