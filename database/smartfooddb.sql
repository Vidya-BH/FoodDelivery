CREATE DATABASE IF NOT EXISTS smartfooddb;
USE smartfooddb;

-- 1. Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    role ENUM('CUSTOMER', 'OWNER', 'ADMIN') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Restaurants Table
CREATE TABLE IF NOT EXISTS restaurants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    cuisine_type VARCHAR(50) NOT NULL,
    delivery_time VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    phone VARCHAR(20) NOT NULL,
    rating DECIMAL(2,1) DEFAULT 4.0,
    image_path VARCHAR(255),
    owner_id INT NOT NULL,
    FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 3. Menus Table
CREATE TABLE IF NOT EXISTS menus (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    image_path VARCHAR(255),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
);

-- 4. Orders Table
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status ENUM('PENDING', 'PREPARING', 'OUT_FOR_DELIVERY', 'DELIVERED', 'CANCELLED') DEFAULT 'PENDING',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    delivery_address TEXT NOT NULL,
    payment_method VARCHAR(50) DEFAULT 'Cash on Delivery',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
);

-- 5. Order Items Table
CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    menu_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (menu_id) REFERENCES menus(id) ON DELETE CASCADE
);

-- Seed Initial Users (Passwords stored in plain-text for ease of testing)
INSERT INTO users (username, password, email, phone, address, role) VALUES
('customer', 'customer123', 'customer@gmail.com', '1234567890', '123 Main St, New York', 'CUSTOMER'),
('owner', 'owner123', 'owner@gmail.com', '9876543210', '456 Elm St, New York', 'OWNER'),
('admin', 'admin123', 'admin@gmail.com', '5555555555', '789 Broadway, New York', 'ADMIN');

-- Seed Restaurants (owned by 'owner' user with id = 2)
INSERT INTO restaurants (name, cuisine_type, delivery_time, address, phone, rating, image_path, owner_id) VALUES
('The Pizza Press', 'Italian', '20-30 min', '120 Broadway, NY', '212-555-0199', 4.7, '/images/pizza_rest.jpg', 2),
('Sushi Zen', 'Japanese', '30-45 min', '85 Fifth Ave, NY', '212-555-0123', 4.8, '/images/sushi_rest.jpg', 2),
('Burger Bistro', 'American', '15-25 min', '340 Madison Ave, NY', '212-555-0145', 4.5, '/images/burger_rest.jpg', 2);

-- Seed Menu Items
-- For 'The Pizza Press' (restaurant_id = 1)
INSERT INTO menus (restaurant_id, item_name, description, price, is_available, image_path) VALUES
(1, 'Margherita Pizza', 'Fresh mozzarella, cherry tomatoes, and basil on thin crust.', 12.99, TRUE, '/images/margherita.jpg'),
(1, 'Pepperoni Pizza', 'Classic crust loaded with cured pepperoni and mozzarella.', 14.99, TRUE, '/images/pepperoni.jpg'),
(1, 'Garlic Herb Breadsticks', 'Warm breadsticks baked with garlic butter and rosemary.', 5.99, TRUE, '/images/garlic_bread.jpg');

-- For 'Sushi Zen' (restaurant_id = 2)
INSERT INTO menus (restaurant_id, item_name, description, price, is_available, image_path) VALUES
(2, 'Classic California Roll', 'Crab mix, avocado, cucumber rolled in sesame seeds.', 8.99, TRUE, '/images/california_roll.jpg'),
(2, 'Premium Salmon Nigiri', 'Sliced fresh raw salmon over vinegared sushi rice.', 11.99, TRUE, '/images/salmon_nigiri.jpg'),
(2, 'Hot Miso Soup', 'Traditional seaweed broth with tofu and green onions.', 3.50, TRUE, '/images/miso_soup.jpg');

-- For 'Burger Bistro' (restaurant_id = 3)
INSERT INTO menus (restaurant_id, item_name, description, price, is_available, image_path) VALUES
(3, 'Classic Cheeseburger', 'Angus beef patty, cheddar, lettuce, tomato, house sauce.', 9.99, TRUE, '/images/cheeseburger.jpg'),
(3, 'Bacon Avocado Burger', 'Beef patty topped with crispy bacon, avocado slice, and Swiss.', 12.50, TRUE, '/images/bacon_burger.jpg'),
(3, 'Gourmet Truffle Fries', 'Thick-cut fries drizzled with white truffle oil and parmesan.', 4.99, TRUE, '/images/truffle_fries.jpg');
