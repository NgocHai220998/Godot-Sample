# Confirm Modal Component Guide

A ready-to-use pop-up modal component for Godot 4.6+ to ask users for confirmation before proceeding with critical actions. It supports smooth intro/outro animations, customizable text, and handles outside overlay clicks.

---

## 🇺🇸 English Guide (Hướng dẫn tiếng Việt nằm ở phần dưới)

### ✨ Core Features
- **Easy Integration**: Dynamically create and show the modal via code without manually placing it in your scene tree.
- **Customizable Content**: Pass a dictionary to easily change the Header, Description, and Button Labels.
- **Juicy Animations**: Built-in scale and fade tweens when opening and closing the modal.
- **Signal-Based Result**: Simple `confirmed(result: bool)` signal makes it trivial to await the user's choice.
- **Smart Overlay**: Click the darkened background to cancel (can be disabled).

### 🚀 Quick Start
You don't need to add this component directly to the Inspector. You can instantiate it anywhere via script whenever a user takes a critical action (like deleting a save or buying an item).

```gdscript
# 1. Spawn the modal passing custom data
var modal = ConfirmModalComponent.release(self, {
	"header": "Warning",
	"description": "Are you sure you want to delete your save file?",
	"cancel": "No, Wait!",
	"ok": "Yes, Delete",
	"animate_in_out": true,
	"cancel_on_overlay_click": false # Force them to click a button
})

# 2. Wait for the user's response
var is_confirmed: bool = await modal.confirmed

if is_confirmed:
	print("Save deleted")
else:
	print("Action cancelled")
```

### 🛠 Configuration Dictionary Properties
When calling `ConfirmModalComponent.release(parent, custom_data)`, you can pass the following keys in the `custom_data` dictionary:

| Key | Type | Default Value | Description |
| :--- | :--- | :--- | :--- |
| **header** | `String` | `"Confirmation Modal"` | The title text of the pop-up. |
| **description** | `String` | `"Are you sure you want to proceed?"`| The main question/message text. |
| **cancel** | `String` | `"Cancel"` | Label text for the Cancel button. |
| **ok** | `String` | `"Confirm"` | Label text for the Confirm/OK button. |
| **cancel_on_overlay_click**| `bool` | `true` | If true, clicking outside the modal box will simulate a Cancel click. |
| **animate_in_out** | `bool` | `true` | Toggles the scale and fade transitions. |

---

## 🇻🇳 Hướng Dẫn Sử Dụng (Vietnamese Guide)

### ✨ Tính Năng Chính
- **Tích hợp dễ dàng**: Gọi và hiển thị bảng thông báo ngay bằng code mà không cần tự tay kéo thả vào Scene Tree.
- **Thay đổi nội dung linh hoạt**: Chỉnh sửa dễ dàng Tiêu đề, Dòng mô tả và Chữ trên 2 nút thông qua một Dictionary.
- **Animation "Juicy"**: Tích hợp sẵn hiệu ứng phóng to nảy nhẹ và mờ dần cực kỳ chuyên nghiệp.
- **Kết quả trả về qua Signal**: Dùng lệnh `await` để chờ tín hiệu `confirmed` của người dùng một cách ngắn gọn hệt như xử lý đồng bộ.
- **Nền thông minh**: Click ra ngoài mảng đen để huỷ nhanh (có thể tắt tính năng này).

### 🚀 Hướng Dẫn Nhanh
Bạn không cần kéo thả file này vào Scene. Bất cứ khi nào cần xác nhận một hành động quan trọng (ví dụ Xoá nhân vật, Mua vật phẩm), hãy gọi nó bằng script:

```gdscript
# 1. Gọi Modal lên và truyền dữ liệu tuỳ chỉnh
var modal = ConfirmModalComponent.release(self, {
	"header": "Cảnh Báo",
	"description": "Bạn có chắc chắn muốn xoá tài khoản này không?",
	"cancel": "Quay Lại",
	"ok": "Xoá Ngay",
	"animate_in_out": true,
	"cancel_on_overlay_click": false # Bắt người dùng phải bấm một trong 2 nút
})

# 2. Chờ kết quả từ người dùng
var is_confirmed: bool = await modal.confirmed

if is_confirmed:
	print("Đã xoá tài khoản")
else:
	print("Đã huỷ thao tác")
```

### 🛠 Các giá trị Cấu Hình (Dictionary)
Khi gọi hàm `ConfirmModalComponent.release(parent, custom_data)`, bạn có thể điền các key sau vào dictionary `custom_data`:

| Key (Khóa) | Kiểu dữ liệu | Giá trị Mặc định | Mô tả |
| :--- | :--- | :--- | :--- |
| **header** | `String` | `"Confirmation Modal"` | Dòng chữ tiêu đề của bảng xác nhận. |
| **description** | `String` | `"Are you sure you want to proceed?"`| Nội dung câu hỏi/cảnh báo chính. |
| **cancel** | `String` | `"Cancel"` | Chữ hiển thị trên nút Huỷ (nút bên trái). |
| **ok** | `String` | `"Confirm"` | Chữ hiển thị trên nút Đồng Ý (nút bên phải). |
| **cancel_on_overlay_click**| `bool` | `true` | Nếu bằng true, click chuột ra màn hình nền đen sẽ tự động Huỷ (Cancel). |
| **animate_in_out** | `bool` | `true` | Bật/tắt hiệu ứng bay ra bay vào của hộp thoại. |
