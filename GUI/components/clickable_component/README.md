# Clickable Component Guide

A powerful and reusable utility component for Godot 4.6+ that turns any **Control** node (like `TextureRect`, `Panel`, `ColorRect`, etc.) into a fully interactive button. It automatically handles hover/click animations, sound effects, debouncing, disabled states, and asynchronous loading flows. 

---

## 🇺🇸 English Guide (Hướng dẫn tiếng Việt nằm ở phần dưới)

### ✨ Core Features
- **Visual FX & Sound FX**: Built-in tween animations for hovering (scale + glow) and clicking (pop). Hooks up directly to your sound manager.
- **Debounce (Anti-spam)**: Built-in click cooldown to prevent users from double-clicking or spamming functions.
- **Async Loading State**: Easily handle network requests or heavy tasks. Hides specified UI elements and shows a loading spinner until a callback is complete.
- **Disabled State**: Lock interactions dynamically. Automatically visualizes the disabled state (e.g., grays out the button).
- **Haptic Feedback**: Automatically triggers a short device vibration on mobile when clicked.

### 🚀 Installation & Setup
1. Add `ClickableComponent.gd` as a child node to the UI element you want to make clickable.
2. Select the `ClickableComponent` node. In the Inspector, it will automatically assign its parent as the **Target Node**.
3. Configure the component via the Inspector (details below).

### 🛠 Configuration (Inspector)
| Group | Property | Description |
| :--- | :--- | :--- |
| **Nodes** | Target Node | The UI element to receive input and apply animations to (default: parent). |
| | Handler Node | The script/node containing the function you want to execute on click. |
| | Method Name | The exact name of the function inside the Handler Node to call. |
| **State** | Disabled | If true, the button ignores clicks/hovers and applies `disabled_modulate`. |
| | Disabled Modulate | The color multiplier applied when the button is disabled. |
| | Click Cooldown | Time in seconds to lock the button after a click (prevents spam). |
| **Loading** | Loading Enabled | If true, clicking triggers an async loading state. |
| | Loading Icon | A Control node (like a spinner) to show during loading. |
| | Nodes To Hide... | Array of Control nodes to hide while loading (e.g., text, icons). |
| **FX** | Visual FX | Tweak colors, transition types, scales, and durations for hover/click. |
| | Sound FX | Assign audio triggers for Hover, Click, Success, and Fail events. |

### 📖 Usage Examples

#### 1. Basic Click (Synchronous)
Used for simple actions like opening a menu or closing a popup.
*   **Inspector Setup**: Leave `Loading Enabled` **OFF**.
*   **Handler Script**: The method takes no arguments (or only default ones).
```gdscript
# Inside your Handler Node script
func on_close_button_clicked() -> void:
	print("Popup closed!")
	queue_free()
```

#### 2. Async Action (With Loading State)
Used for actions that take time, like purchasing an item or saving to a server.
*   **Inspector Setup**: Turn `Loading Enabled` **ON**. Assign a `Loading Icon`.
*   **Handler Script**: The method **MUST** accept a `Callable` argument. You must call this callback when your task is finished.
```gdscript
# Inside your Handler Node script
func on_buy_item_clicked(callback: Callable) -> void:
	print("Processing purchase...")
	
	# Simulate network delay
	await get_tree().create_timer(1.5).timeout 
	
	var is_success = true # Determine if the action worked
	
	# End the loading state and trigger appropriate success/fail sounds
	callback.call(is_success)
```
*(If `is_success` is false, the component emits the `action_failed` signal).*

---

## 🇻🇳 Hướng Dẫn Sử Dụng (Vietnamese Guide)

### ✨ Tính Năng Chính
- **Visual FX & Sound FX**: Tích hợp sẵn hiệu ứng animation mượt mà khi di chuột (phóng to + phát sáng) và khi click (nảy lên). Dễ dàng gắn âm thanh tương ứng.
- **Chống Spam (Debounce)**: Có thời gian hồi (cooldown) để ngăn người chơi bấm đúp hoặc click liên tục làm lỗi logic game.
- **Trạng Thái Loading (Async)**: Hỗ trợ tự động hiển thị icon chờ, ẩn chữ/icon cũ, và khóa nút cho đến khi tác vụ nền chạy xong.
- **Trạng Thái Vô Hiệu Hóa (Disabled)**: Có thể khóa nút bằng code hoặc Inspector. Tự động đổi màu nút sang tông xám (hoặc màu tùy chỉnh) khi bị khóa.
- **Haptic Feedback**: Tự động rung nhẹ thiết bị khi click nếu chơi trên nền tảng Mobile.

### 🚀 Cài Đặt & Khởi Tạo
1. Thêm `ClickableComponent.gd` làm node con của UI element mà bạn muốn biến thành nút bấm.
2. Chọn node `ClickableComponent`. Trong bảng Inspector, nó sẽ tự động nhận node cha làm **Target Node**.
3. Tùy chỉnh các thông số trong bảng Inspector.

### 🛠 Cấu Hình (Bảng Inspector)
| Nhóm | Thuộc tính | Mô tả |
| :--- | :--- | :--- |
| **Nodes** | Target Node | UI element sẽ nhận tương tác và hiệu ứng (mặc định: node cha). |
| | Handler Node | Node chứa đoạn mã (script) sẽ thực thi khi nút được click. |
| | Method Name | Tên chính xác của hàm nằm trong Handler Node trên. |
| **State** | Disabled | Bật/tắt nút. Nếu bật, nút sẽ không nhận tương tác và bị đổi màu. |
| | Disabled Modulate | Màu hiển thị khi nút bị khóa (mặc định là xám mờ). |
| | Click Cooldown | Thời gian chờ giữa 2 lần click (để ngăn spam bấm đúp). |
| **Loading** | Loading Enabled | Nếu bật, Click sẽ yêu cầu xử lý logic bất đồng bộ (Loading). |
| | Loading Icon | Node (ví dụ vòng xoay) sẽ hiện lên khi đang Loading. |
| | Nodes To Hide... | Danh sách các Control node sẽ bị ẩn đi trong lúc Loading (như Text). |
| **FX** | Visual FX | Tùy chỉnh cường độ phóng to, tốc độ, kiểu chuyển động, v.v. |
| | Sound FX | Gán âm thanh cho các sự kiện: Hover, Click, Thành công, Thất bại. |

### 📖 Ví Dụ Sử Dụng

#### 1. Click Thông Thường (Đồng Bộ)
Dùng cho các hành động nhanh như đóng/mở menu.
*   **Thiết lập Inspector**: Tắt `Loading Enabled`.
*   **Script ở Handler**: Hàm không cần nhận tham số nào.
```gdscript
# Viết trong script của Handler Node
func on_close_button_clicked() -> void:
	print("Đã đóng Cửa sổ!")
	queue_free()
```

#### 2. Click Xử Lý Bất Đồng Bộ (Có Loading)
Dùng cho các tác vụ tốn thời gian như mua đồ, lưu game, gọi API.
*   **Thiết lập Inspector**: Bật `Loading Enabled`. Kéo thả một `Loading Icon` vào.
*   **Script ở Handler**: Hàm **BẮT BUỘC** phải nhận một tham số là `Callable`. Bạn phải gọi callback này khi xử lý xong tác vụ.
```gdscript
# Viết trong script của Handler Node
func on_buy_item_clicked(callback: Callable) -> void:
	print("Đang xử lý thanh toán...")
	
	# Giả lập thời gian chờ server
	await get_tree().create_timer(1.5).timeout 
	
	var is_success = true # Kiểm tra xem việc mua có thành công không
	
	# Kết thúc trạng thái chờ loading, báo cho Component biết kết quả
	callback.call(is_success)
```
*(Nếu `is_success` là `false`, component sẽ tự động phát signal `action_failed`).*
