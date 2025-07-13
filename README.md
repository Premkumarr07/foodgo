# 🍔 FoodGo – Flutter Food-Delivery App (COD Only)

A **complete, Stripe-free** food-ordering application built with **Flutter**, **Firebase Auth**, and **Firestore**.  
Browse dishes, manage your cart, and place orders with **Cash on Delivery**—no payment-gateway integration required.

---

## 📱 App Screenshots

| Home | Cart | Checkout | Order Tracking |
|------|------|----------|----------------|
| ![Home](assets/1000062228.png?raw=true) | ![Cart](assets/1000062226.png?raw=true) | ![Checkout](assets/1000062229.png?raw=true) | ![Tracking](assets/1000062240.png?raw=true) |

---

## ✨ Features

- 🔐 **Email & Password Authentication**
- 🍽️ **Category & Product Browsing** *(with live Firestore data)*
- 🛒 **Full Cart Management** *(add, remove, quantity change)*
- 🏠 **Address & Special Instructions** form
- 🚚 **Cash-on-Delivery only** *(no Stripe, no payment-gateway)*
- 📱 **Responsive Material-3 UI** *(light & dark ready)*
- 🔄 **Real-time Firestore sync**

---

## 🚀 Tech Stack

| Layer       | Tech                                                                 |
|-------------|----------------------------------------------------------------------|
| Frontend    | Flutter 3.x stable                                                   |
| State Mgmt  | `provider`, `ChangeNotifier`                                         |
| Backend     | Firebase Auth + Firestore                                            |
| CI / Build  | Gradle 8.x + Kotlin 1.9+                                             |

---

## 🛠️ Getting Started

### 1. Prerequisites
- Flutter SDK (stable channel)
- Java 17 JDK configured for Flutter
- Firebase CLI & Git

### 2. Clone & Install
```bash
git clone https://github.com/YOUR_USERNAME/foodgo.git
cd foodgo
flutter pub get