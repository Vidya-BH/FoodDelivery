package com.food.model;

import java.io.Serializable;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

public class Cart implements Serializable {
    private static final long serialVersionUID = 1L;

    private Map<Integer, CartItem> items;

    public Cart() {
        this.items = new HashMap<>();
    }

    public void addItem(Menu menu, int quantity) {
        int menuId = menu.getId();
        if (items.containsKey(menuId)) {
            CartItem existing = items.get(menuId);
            existing.setQuantity(existing.getQuantity() + quantity);
        } else {
            items.put(menuId, new CartItem(menu, quantity));
        }
    }

    public void updateQuantity(int menuId, int quantity) {
        if (items.containsKey(menuId)) {
            if (quantity <= 0) {
                items.remove(menuId);
            } else {
                items.get(menuId).setQuantity(quantity);
            }
        }
    }

    public void removeItem(int menuId) {
        items.remove(menuId);
    }

    public Collection<CartItem> getItems() {
        return items.values();
    }

    public double getTotalPrice() {
        double total = 0;
        for (CartItem item : items.values()) {
            total += item.getSubtotal();
        }
        return total;
    }

    public int getTotalQuantity() {
        int count = 0;
        for (CartItem item : items.values()) {
            count += item.getQuantity();
        }
        return count;
    }

    public void clear() {
        items.clear();
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }
}
