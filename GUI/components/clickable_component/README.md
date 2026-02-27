# Clickable Component

A utility component for Godot 4.6 or later that makes any **Control** node interactive. It handles click/hover events, visual feedback (scaling/glow), sound effects, and async loading states automatically.

---

## English Version

### 🚀 Quick Start
1. Add `ClickableComponent` as a child of any UI element (e.g., `TextureRect`, `Panel`).
2. **Setup Nodes**:
   - `Target Node`: The UI element to receive input (default: parent).
   - `Handler Node`: The script that contains the logic to execute.
   - `Method Name`: The function name to call on the Handler.
3. **Customize FX**:
   - Toggle Scale/Glow in the **Visual FX** section.
   - Assign sounds in the **Sound FX** section.

### 🔄 Loading State
If `Loading Enabled` is ON:
- The Handler function must accept a callback: `func my_method(node, callback: Callable)`.
- When clicked, `nodes_to_hide` will vanish, and the `loading_icon` will appear.
- Call `callback.call(true)` in your logic to finish the loading state.

---

## 🇻🇳 Tiếng Việt

### 🚀 Hướng dẫn nhanh
1. Thêm `ClickableComponent` làm con của bất kỳ UI element nào (ví dụ: `TextureRect`, `Panel`).
2. **Cài đặt Node**:
   - `Target Node`: Node UI sẽ nhận tương tác (mặc định là node cha).
   - `Handler Node`: Node chứa script xử lý logic khi click.
   - `Method Name`: Tên hàm sẽ được gọi trong Handler Node.
3. **Tùy chỉnh Hiệu ứng**:
   - Chỉnh Scale/Glow trong mục **Visual FX**.
   - Gán âm thanh trong mục **Sound FX**.

### 🔄 Trạng thái Loading
Nếu bật `Loading Enabled`:
- Hàm trong Handler phải nhận một callback: `func my_method(node, callback: Callable)`.
- Khi click, các node trong `nodes_to_hide` sẽ ẩn đi và `loading_icon` hiện lên.
- Gọi `callback.call(true)` trong logic của bạn để kết thúc trạng thái loading.

---
