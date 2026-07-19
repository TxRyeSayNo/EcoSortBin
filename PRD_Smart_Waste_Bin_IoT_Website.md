# PRODUCT REQUIREMENTS DOCUMENT (PRD)
## Website giám sát hệ thống thùng rác thông minh IoT

---

## 0. Thông tin tài liệu

| Thuộc tính | Nội dung |
|---|---|
| Tên sản phẩm | Smart Waste Bin IoT Dashboard |
| Loại tài liệu | Product Requirements Document (PRD) |
| Phiên bản | 1.0 |
| Trạng thái | Draft dùng để thống nhất yêu cầu và triển khai |
| Ngôn ngữ giao diện | Tiếng Việt |
| Đối tượng sử dụng | Quản trị viên, giảng viên đánh giá, nhóm phát triển |
| Nền tảng | Website responsive trên trình duyệt |
| Backend chính | Java Servlet chạy trên Apache Tomcat |
| View layer | JSP, JSTL, HTML5, CSS3, JavaScript |
| Cơ sở dữ liệu | Supabase PostgreSQL |
| Giao tiếp thiết bị | Wi-Fi + HTTP REST API |
| Thiết bị IoT | ESP32, ESP32-CAM, Arduino Uno và các cảm biến/cơ cấu liên quan |
| Phạm vi phân loại | Nhựa, kim loại, thủy tinh |
| Mục đích chính | Giám sát trạng thái thiết bị, hiển thị thông báo, lưu lịch sử và thống kê kết quả phân loại rác |

---

# 1. Tóm tắt sản phẩm

Smart Waste Bin IoT Dashboard là một website quản trị nhỏ phục vụ hệ thống thùng rác thông minh có khả năng nhận diện và phân loại ba nhóm rác gồm nhựa, kim loại và thủy tinh.

Hệ thống vật lý sử dụng camera và mô hình nhận diện để xác định loại rác. Sau khi kết quả được xác định, vi điều khiển điều khiển servo để đưa rác vào đúng ngăn. Đồng thời, ESP32 kết nối Wi-Fi và gửi dữ liệu sự kiện lên backend Java Servlet thông qua HTTP REST API. Backend chịu trách nhiệm xác thực thiết bị, kiểm tra dữ liệu, lưu kết quả vào PostgreSQL trên Supabase và cung cấp dữ liệu cho giao diện quản trị.

Website tập trung vào bốn giá trị chính:

1. Theo dõi trạng thái thùng rác từ xa.
2. Hiển thị thông báo theo thời gian gần thực.
3. Lưu lịch sử từng lần nhận diện và phân loại.
4. Tổng hợp dữ liệu thành các chỉ số và biểu đồ phục vụ đánh giá hệ thống.

Website không phải là một hệ thống quản lý rác đô thị quy mô lớn. Phiên bản đầu được thiết kế cho một nguyên mẫu học thuật, ưu tiên tính rõ ràng, khả thi, dễ demo và dễ dùng làm dữ liệu minh họa cho bài báo IoT.

---

# 2. Bối cảnh và vấn đề cần giải quyết

Việc phân loại rác tại nguồn thường phụ thuộc vào ý thức và khả năng nhận biết của người dùng. Trong môi trường trường học, văn phòng hoặc khu vực công cộng, người dùng có thể bỏ rác sai ngăn do thiếu chú ý, không hiểu ký hiệu hoặc không xác định được vật liệu của rác.

Hệ thống thùng rác thông minh được xây dựng để hỗ trợ tự động hóa quá trình này. Tuy nhiên, một thiết bị chỉ hoạt động cục bộ sẽ gặp các hạn chế sau:

- Không theo dõi được số lượng rác đã xử lý.
- Không biết thiết bị còn online hay đã mất kết nối.
- Không có lịch sử để đánh giá độ chính xác.
- Khó phát hiện các lần nhận diện thất bại hoặc servo hoạt động lỗi.
- Không có dữ liệu trực quan để phục vụ báo cáo, kiểm thử và bảo trì.
- Không thể chứng minh rõ thành phần IoT nếu thiết bị không truyền dữ liệu lên Internet.

Website được bổ sung để giải quyết các hạn chế trên. Nó biến nguyên mẫu từ một hệ thống nhúng cục bộ thành một hệ thống IoT có lớp thiết bị, lớp truyền thông, lớp xử lý, lớp lưu trữ và lớp ứng dụng.

---

# 3. Mục tiêu sản phẩm

## 3.1. Mục tiêu chính

Website phải cho phép quản trị viên xem được trạng thái hiện tại của thùng rác, lịch sử các lần phân loại, thông báo mới nhất và số liệu thống kê theo từng loại rác.

## 3.2. Mục tiêu kỹ thuật

- Nhận dữ liệu từ ESP32 bằng HTTP POST.
- Xác thực thiết bị trước khi ghi dữ liệu.
- Lưu dữ liệu vào Supabase PostgreSQL.
- Cung cấp API cho frontend/JSP.
- Hiển thị dữ liệu theo thời gian gần thực.
- Phân biệt ba loại rác: `PLASTIC`, `METAL`, `GLASS`.
- Hỗ trợ trạng thái `UNKNOWN` khi mô hình không đủ độ tin cậy.
- Không làm thiết bị vật lý phụ thuộc hoàn toàn vào Internet.
- Không để khóa bí mật của Supabase trên ESP32 hoặc frontend.
- Có cấu trúc đủ rõ để mở rộng nhiều thiết bị trong tương lai.

## 3.3. Mục tiêu học thuật

- Thể hiện đầy đủ kiến trúc IoT nhiều lớp.
- Có dữ liệu thực nghiệm để đưa vào bài báo.
- Có giao diện trực quan để minh họa luồng dữ liệu.
- Có thể đo độ chính xác, thời gian xử lý, tỷ lệ thành công và số lỗi.
- Có thể giải thích rõ vai trò của Java Servlet, PostgreSQL, ESP32 và dashboard.

---

# 4. Phạm vi sản phẩm

## 4.1. Trong phạm vi phiên bản 1.0

- Đăng nhập quản trị viên.
- Dashboard tổng quan.
- Trạng thái online/offline của thiết bị.
- Thẻ thống kê tổng số rác.
- Thống kê riêng cho nhựa, kim loại và thủy tinh.
- Hiển thị số lần nhận diện không xác định.
- Hiển thị số lần phân luồng thất bại.
- Danh sách thông báo.
- Lịch sử phân loại.
- Bộ lọc theo loại rác, trạng thái và thời gian.
- Biểu đồ phân bố loại rác.
- Biểu đồ số lượt xử lý theo ngày.
- Trang chi tiết thiết bị.
- API nhận sự kiện từ ESP32.
- API lấy dữ liệu dashboard.
- Lưu dữ liệu vào Supabase PostgreSQL.
- Phân quyền ở mức một vai trò quản trị viên.
- Giao diện responsive cơ bản cho desktop và tablet.

## 4.2. Ngoài phạm vi phiên bản 1.0

- Ứng dụng mobile native.
- Quản lý thu gom rác toàn thành phố.
- Điều phối xe thu gom.
- Thanh toán hoặc điểm thưởng.
- GPS thời gian thực.
- Điều khiển servo từ xa qua website.
- Cập nhật firmware OTA.
- Nhận diện nhiều vật trong cùng một ảnh.
- Quản lý hàng trăm nghìn thiết bị.
- Phân quyền nhiều cấp phức tạp.
- Tích hợp bản đồ GIS.
- Tự động gửi SMS.
- Xử lý video trực tiếp trên website.
- Lưu toàn bộ hình ảnh camera trên cloud.
- Chức năng thương mại điện tử.

## 4.3. Phạm vi mở rộng tương lai

- Quản lý nhiều thùng rác.
- Cảm biến mức đầy.
- Cảnh báo ngăn sắp đầy.
- Email hoặc thông báo đẩy.
- WebSocket hoặc Server-Sent Events.
- MQTT broker.
- Hệ thống bảo trì.
- Điều khiển từ xa có phân quyền.
- Vai trò Admin, Operator và Viewer.
- Xuất báo cáo CSV/PDF.
- So sánh dữ liệu giữa nhiều vị trí.
- Phát hiện pin yếu.
- Lưu ảnh các trường hợp nhận diện sai.
- Dashboard nghiên cứu mô hình AI.

---

# 5. Người dùng mục tiêu

## 5.1. Quản trị viên hệ thống

Đây là người dùng chính trong phiên bản đầu.

Nhu cầu:

- Xem thiết bị có hoạt động hay không.
- Xem loại rác vừa được nhận diện.
- Xem các sự kiện lỗi.
- Kiểm tra số lượng từng loại rác.
- Xem lịch sử để đối chiếu khi thử nghiệm.
- Theo dõi độ tin cậy và thời gian xử lý.
- Xem dữ liệu trực quan khi trình bày dự án.

## 5.2. Thành viên nhóm phát triển

Nhu cầu:

- Kiểm tra ESP32 đã gửi dữ liệu thành công chưa.
- Kiểm tra cấu trúc JSON.
- Theo dõi lỗi xác thực thiết bị.
- Đối chiếu dữ liệu AI với kết quả phân luồng.
- Lấy số liệu làm báo cáo và bài báo.

## 5.3. Giảng viên hoặc người đánh giá

Nhu cầu:

- Quan sát hệ thống hoạt động.
- Xem bằng chứng dữ liệu được truyền lên Internet.
- Xem lịch sử thực nghiệm.
- Đánh giá khả năng ứng dụng của sản phẩm.
- Hiểu rõ kiến trúc IoT và công nghệ sử dụng.

---

# 6. User stories

## 6.1. Xác thực

- Là quản trị viên, tôi muốn đăng nhập để chỉ người được cấp quyền mới xem được dữ liệu.
- Là quản trị viên, tôi muốn đăng xuất để kết thúc phiên sử dụng.
- Là hệ thống, tôi muốn tự động chuyển người chưa đăng nhập về trang đăng nhập.

## 6.2. Dashboard

- Là quản trị viên, tôi muốn xem tổng số rác đã được xử lý.
- Là quản trị viên, tôi muốn xem số lượng nhựa, kim loại và thủy tinh.
- Là quản trị viên, tôi muốn biết thiết bị online hay offline.
- Là quản trị viên, tôi muốn xem sự kiện mới nhất mà không phải mở nhiều trang.
- Là quản trị viên, tôi muốn xem tỷ lệ phân loại thành công.

## 6.3. Lịch sử

- Là quản trị viên, tôi muốn xem toàn bộ lịch sử phân loại.
- Là quản trị viên, tôi muốn lọc theo loại rác.
- Là quản trị viên, tôi muốn lọc các lần thất bại.
- Là quản trị viên, tôi muốn xem confidence của từng lần nhận diện.
- Là quản trị viên, tôi muốn xem thời gian xử lý của từng lần.
- Là quản trị viên, tôi muốn mở chi tiết một sự kiện.

## 6.4. Thông báo

- Là quản trị viên, tôi muốn biết khi thiết bị offline.
- Là quản trị viên, tôi muốn biết khi confidence thấp.
- Là quản trị viên, tôi muốn biết khi phân luồng thất bại.
- Là quản trị viên, tôi muốn đánh dấu thông báo đã đọc.
- Là quản trị viên, tôi muốn lọc thông báo theo mức độ.

## 6.5. Thiết bị

- Là quản trị viên, tôi muốn xem mã và vị trí thiết bị.
- Là quản trị viên, tôi muốn xem thời điểm thiết bị gửi dữ liệu gần nhất.
- Là quản trị viên, tôi muốn xem phiên bản firmware nếu thiết bị gửi thông tin này.
- Là quản trị viên, tôi muốn xem tổng số sự kiện của thiết bị.

## 6.6. Thiết bị IoT

- Là ESP32, tôi muốn gửi sự kiện phân loại lên server.
- Là ESP32, tôi muốn nhận phản hồi rõ ràng khi server ghi dữ liệu thành công.
- Là ESP32, tôi muốn nhận mã lỗi khi dữ liệu không hợp lệ.
- Là ESP32, tôi muốn gửi heartbeat để server xác định trạng thái online.
- Là hệ thống, tôi muốn từ chối yêu cầu có device token không hợp lệ.

---

# 7. Kiến trúc tổng thể

## 7.1. Sơ đồ logic

```text
Vật rác
   ↓
Cảm biến phát hiện
   ↓
ESP32-CAM chụp ảnh và nhận diện
   ↓
Kết quả: PLASTIC / METAL / GLASS / UNKNOWN
   ↓
ESP32 điều khiển servo và OLED
   ↓
ESP32 kết nối Wi-Fi
   ↓ HTTP POST + JSON
Java Servlet API trên Tomcat
   ↓ JDBC
Supabase PostgreSQL
   ↓
JSP / JavaScript Dashboard
   ↓
Quản trị viên
```

## 7.2. Phân lớp IoT

### Lớp cảm nhận — Perception Layer

Thành phần:

- Camera ESP32-CAM.
- Cảm biến hồng ngoại.
- Servo.
- Các tín hiệu trạng thái.

Nhiệm vụ:

- Phát hiện vật.
- Thu nhận hình ảnh.
- Nhận diện loại rác.
- Thực hiện hành động vật lý.

### Lớp mạng — Network Layer

Thành phần:

- Wi-Fi.
- HTTP/HTTPS.
- UART giữa các board.
- I2C với OLED.
- GPIO/PWM với cảm biến và servo.

Nhiệm vụ:

- Truyền kết quả giữa các board.
- Gửi sự kiện lên backend.
- Nhận phản hồi từ server.

### Lớp xử lý — Processing Layer

Thành phần:

- Java Servlet.
- Service layer.
- DAO layer.
- PostgreSQL.

Nhiệm vụ:

- Xác thực.
- Kiểm tra dữ liệu.
- Lưu trữ.
- Tổng hợp thống kê.
- Sinh thông báo.

### Lớp ứng dụng — Application Layer

Thành phần:

- JSP.
- HTML/CSS/JavaScript.
- Biểu đồ.
- Dashboard.

Nhiệm vụ:

- Hiển thị trạng thái.
- Hiển thị thông báo.
- Hiển thị lịch sử.
- Trực quan hóa dữ liệu.

---

# 8. Công nghệ và ngôn ngữ

## 8.1. Backend

### Java

Phiên bản đề xuất:

- Java 17 LTS.

Lý do:

- Ổn định.
- Tương thích tốt với môi trường học tập hiện đại.
- Hỗ trợ API và syntax mới hơn Java 8.
- Dễ triển khai với Tomcat 10 nếu dùng Jakarta Servlet.

### Servlet API

Có hai lựa chọn:

#### Lựa chọn A — Jakarta Servlet

- Package: `jakarta.servlet.*`
- Server đề xuất: Tomcat 10.1+
- Phù hợp cho dự án mới.

#### Lựa chọn B — Javax Servlet

- Package: `javax.servlet.*`
- Server đề xuất: Tomcat 9
- Chỉ dùng nếu môn học hoặc project template hiện tại bắt buộc.

Quyết định kỹ thuật phải thống nhất ngay từ đầu. Không được trộn `javax.servlet` và `jakarta.servlet` trong cùng project.

### JSP và JSTL

- JSP dùng để dựng trang.
- JSTL dùng cho vòng lặp, điều kiện và định dạng.
- Hạn chế viết Java scriptlet trực tiếp trong JSP.
- Dữ liệu nên được chuẩn bị tại Servlet và truyền qua request/session.

### JDBC

- Driver: PostgreSQL JDBC Driver.
- Dùng để kết nối trực tiếp Java Servlet với Supabase PostgreSQL.
- Không để thông tin kết nối trong source code.
- Sử dụng biến môi trường hoặc file cấu hình ngoài repository.

### JSON

Đề xuất dùng một trong hai thư viện:

- Jackson Databind.
- Gson.

Khuyến nghị: Jackson để xử lý DTO rõ ràng và mở rộng dễ hơn.

### Build tool

Khuyến nghị:

- Maven.

Mục đích:

- Quản lý dependency.
- Build WAR.
- Chạy test.
- Chuẩn hóa cấu trúc project.

## 8.2. Frontend

### JSP

- Dùng làm view layer.
- Render layout chính.
- Render dữ liệu khởi tạo.
- Gọi API bằng JavaScript khi cần cập nhật định kỳ.

### HTML5

- Sử dụng semantic HTML.
- Có `header`, `nav`, `main`, `section`, `table`, `form`.
- Bảo đảm nhãn form đầy đủ.

### CSS3

- Có file token màu dùng CSS variables.
- Không viết style inline tràn lan.
- Sử dụng Flexbox và CSS Grid.
- Responsive theo desktop, tablet và mobile.

### JavaScript

- JavaScript thuần ES6+ là đủ cho phiên bản đầu.
- Dùng `fetch()` gọi REST API.
- Dùng polling 5 giây cho dashboard.
- Dùng Chart.js cho biểu đồ.
- Không bắt buộc React hoặc Next.js vì mục tiêu học Java Servlet.

### Thư viện FE

Đề xuất:

- Chart.js cho biểu đồ.
- Lucide Icons hoặc Font Awesome cho icon.
- Không nên dùng quá nhiều framework giao diện nếu muốn dễ kiểm soát.

## 8.3. Cơ sở dữ liệu

### Supabase PostgreSQL

Vai trò:

- Cloud database.
- Lưu tài khoản.
- Lưu thiết bị.
- Lưu sự kiện phân loại.
- Lưu thông báo.
- Lưu heartbeat hoặc trạng thái nếu cần.

Lưu ý:

- Supabase không thay thế vai trò Java Servlet trong kiến trúc này.
- Servlet là backend chính.
- Supabase được dùng như PostgreSQL được quản lý trên cloud.
- Không đưa service key hoặc database password lên frontend/ESP32.

## 8.4. Server ứng dụng

- Apache Tomcat.
- Development: chạy local.
- Demo: deploy Tomcat lên VPS hoặc dịch vụ hỗ trợ Java WAR.
- Nếu chưa deploy cloud, có thể dùng tunnel để demo ESP32 gửi dữ liệu vào máy local, nhưng đây chỉ là giải pháp trình diễn.

## 8.5. Giao tiếp IoT

- Transport: Wi-Fi.
- Application protocol: HTTP.
- Data format: JSON.
- API style: REST.
- Bảo mật tối thiểu: device token.
- Khuyến nghị production: HTTPS.

---

# 9. Cấu trúc project đề xuất

```text
smart-waste-bin/
├─ pom.xml
├─ README.md
├─ .env.example
├─ src/
│  ├─ main/
│  │  ├─ java/
│  │  │  └─ com.smartbin/
│  │  │     ├─ controller/
│  │  │     │  ├─ auth/
│  │  │     │  ├─ dashboard/
│  │  │     │  ├─ history/
│  │  │     │  ├─ notification/
│  │  │     │  ├─ device/
│  │  │     │  └─ api/
│  │  │     ├─ service/
│  │  │     ├─ dao/
│  │  │     ├─ model/
│  │  │     ├─ dto/
│  │  │     ├─ filter/
│  │  │     ├─ util/
│  │  │     ├─ exception/
│  │  │     └─ config/
│  │  ├─ resources/
│  │  │  ├─ application.properties
│  │  │  └─ logback.xml
│  │  └─ webapp/
│  │     ├─ assets/
│  │     │  ├─ css/
│  │     │  │  ├─ tokens.css
│  │     │  │  ├─ base.css
│  │     │  │  ├─ layout.css
│  │     │  │  ├─ components.css
│  │     │  │  └─ pages/
│  │     │  ├─ js/
│  │     │  │  ├─ api.js
│  │     │  │  ├─ dashboard.js
│  │     │  │  ├─ history.js
│  │     │  │  └─ notifications.js
│  │     │  └─ images/
│  │     ├─ WEB-INF/
│  │     │  ├─ views/
│  │     │  │  ├─ auth/
│  │     │  │  ├─ dashboard/
│  │     │  │  ├─ history/
│  │     │  │  ├─ notifications/
│  │     │  │  ├─ devices/
│  │     │  │  └─ errors/
│  │     │  └─ web.xml
│  │     └─ index.jsp
│  └─ test/
│     └─ java/
└─ docs/
   ├─ api.md
   ├─ database.md
   └─ deployment.md
```

---

# 10. Thiết kế cơ sở dữ liệu

## 10.1. Bảng `users`

```sql
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(30) NOT NULL DEFAULT 'ADMIN',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

Quy tắc:

- Email duy nhất.
- Không lưu mật khẩu dạng plain text.
- Dùng BCrypt.
- Phiên bản đầu chỉ cần role `ADMIN`.

## 10.2. Bảng `devices`

```sql
CREATE TABLE devices (
    id BIGSERIAL PRIMARY KEY,
    device_code VARCHAR(50) NOT NULL UNIQUE,
    device_name VARCHAR(100) NOT NULL,
    location VARCHAR(255),
    device_token_hash VARCHAR(255) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'OFFLINE',
    firmware_version VARCHAR(30),
    last_seen_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

Giá trị `status`:

- `ONLINE`
- `OFFLINE`
- `WARNING`
- `ERROR`

## 10.3. Bảng `waste_events`

```sql
CREATE TABLE waste_events (
    id BIGSERIAL PRIMARY KEY,
    device_id BIGINT NOT NULL,
    waste_type VARCHAR(20) NOT NULL,
    confidence NUMERIC(5,2),
    classification_time_ms INTEGER,
    sorting_time_ms INTEGER,
    total_processing_time_ms INTEGER,
    sorting_success BOOLEAN NOT NULL DEFAULT TRUE,
    sensor_confirmed BOOLEAN,
    error_code VARCHAR(50),
    raw_message JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_waste_event_device
        FOREIGN KEY (device_id)
        REFERENCES devices(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_waste_type
        CHECK (waste_type IN ('PLASTIC', 'METAL', 'GLASS', 'UNKNOWN')),

    CONSTRAINT chk_confidence
        CHECK (confidence IS NULL OR (confidence >= 0 AND confidence <= 100))
);
```

## 10.4. Bảng `notifications`

```sql
CREATE TABLE notifications (
    id BIGSERIAL PRIMARY KEY,
    device_id BIGINT NOT NULL,
    waste_event_id BIGINT,
    type VARCHAR(50) NOT NULL,
    severity VARCHAR(20) NOT NULL,
    title VARCHAR(150) NOT NULL,
    message VARCHAR(500) NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    read_at TIMESTAMPTZ,

    CONSTRAINT fk_notification_device
        FOREIGN KEY (device_id)
        REFERENCES devices(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_notification_event
        FOREIGN KEY (waste_event_id)
        REFERENCES waste_events(id)
        ON DELETE SET NULL,

    CONSTRAINT chk_notification_severity
        CHECK (severity IN ('INFO', 'SUCCESS', 'WARNING', 'ERROR'))
);
```

## 10.5. Bảng `device_heartbeats`

```sql
CREATE TABLE device_heartbeats (
    id BIGSERIAL PRIMARY KEY,
    device_id BIGINT NOT NULL,
    wifi_rssi INTEGER,
    free_heap INTEGER,
    uptime_seconds BIGINT,
    firmware_version VARCHAR(30),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_heartbeat_device
        FOREIGN KEY (device_id)
        REFERENCES devices(id)
        ON DELETE CASCADE
);
```

## 10.6. Chỉ mục đề xuất

```sql
CREATE INDEX idx_waste_events_device_created
ON waste_events(device_id, created_at DESC);

CREATE INDEX idx_waste_events_type
ON waste_events(waste_type);

CREATE INDEX idx_waste_events_success
ON waste_events(sorting_success);

CREATE INDEX idx_notifications_device_created
ON notifications(device_id, created_at DESC);

CREATE INDEX idx_notifications_unread
ON notifications(is_read)
WHERE is_read = FALSE;

CREATE INDEX idx_heartbeats_device_created
ON device_heartbeats(device_id, created_at DESC);
```

---

# 11. Thiết kế API

## 11.1. Quy ước chung

Base path:

```text
/api
```

Content type:

```text
application/json
```

Thiết bị gửi headers:

```text
X-Device-Code: SMART_BIN_001
X-Device-Token: <device-secret>
Content-Type: application/json
```

Response chuẩn:

```json
{
  "success": true,
  "message": "Request processed successfully",
  "data": {},
  "timestamp": "2026-07-11T20:35:12Z"
}
```

Response lỗi:

```json
{
  "success": false,
  "message": "Invalid device token",
  "errorCode": "DEVICE_AUTH_FAILED",
  "timestamp": "2026-07-11T20:35:12Z"
}
```

## 11.2. API nhận sự kiện phân loại

```http
POST /api/iot/waste-events
```

Request:

```json
{
  "wasteType": "GLASS",
  "confidence": 91.5,
  "classificationTimeMs": 1120,
  "sortingTimeMs": 700,
  "totalProcessingTimeMs": 1820,
  "sortingSuccess": true,
  "sensorConfirmed": true
}
```

Validation:

- `wasteType` bắt buộc.
- Chỉ nhận `PLASTIC`, `METAL`, `GLASS`, `UNKNOWN`.
- `confidence` từ 0 đến 100.
- Các trường thời gian không âm.
- `sortingSuccess` bắt buộc.
- Thiết bị phải tồn tại.
- Token phải hợp lệ.

Response thành công:

```json
{
  "success": true,
  "message": "Waste event recorded",
  "data": {
    "eventId": 125
  }
}
```

## 11.3. API heartbeat

```http
POST /api/iot/heartbeat
```

Request:

```json
{
  "wifiRssi": -57,
  "freeHeap": 184320,
  "uptimeSeconds": 28650,
  "firmwareVersion": "1.0.0"
}
```

Hành vi:

- Cập nhật `last_seen_at`.
- Cập nhật trạng thái thiết bị thành `ONLINE`.
- Lưu heartbeat nếu cần phân tích.

## 11.4. API dashboard

```http
GET /api/dashboard/summary
```

Response:

```json
{
  "success": true,
  "data": {
    "device": {
      "code": "SMART_BIN_001",
      "name": "Smart Bin 001",
      "status": "ONLINE",
      "lastSeenAt": "2026-07-11T20:35:12Z"
    },
    "statistics": {
      "total": 148,
      "plastic": 62,
      "metal": 47,
      "glass": 39,
      "unknown": 4,
      "failed": 5,
      "successRate": 96.62,
      "averageProcessingTimeMs": 1765
    }
  }
}
```

## 11.5. API lịch sử

```http
GET /api/waste-events
```

Query parameters:

- `page`
- `size`
- `wasteType`
- `success`
- `from`
- `to`
- `sort`

Ví dụ:

```text
/api/waste-events?page=1&size=20&wasteType=GLASS&success=true
```

## 11.6. API chi tiết sự kiện

```http
GET /api/waste-events/{id}
```

## 11.7. API thông báo

```http
GET /api/notifications
PATCH /api/notifications/{id}/read
PATCH /api/notifications/read-all
```

## 11.8. API biểu đồ

```http
GET /api/statistics/by-type
GET /api/statistics/by-day?days=7
GET /api/statistics/success-rate
```

---

# 12. Quy tắc sinh thông báo

| Điều kiện | Loại | Mức độ | Nội dung |
|---|---|---|---|
| Phân loại thành công | `WASTE_CLASSIFIED` | `SUCCESS` | Đã phân loại loại rác tương ứng |
| Confidence dưới ngưỡng | `LOW_CONFIDENCE` | `WARNING` | Độ tin cậy thấp |
| `sortingSuccess = false` | `SORTING_FAILED` | `ERROR` | Phân luồng thất bại |
| Thiết bị quá thời gian heartbeat | `DEVICE_OFFLINE` | `ERROR` | Thiết bị mất kết nối |
| Thiết bị online trở lại | `DEVICE_ONLINE` | `INFO` | Thiết bị đã kết nối lại |
| Lỗi servo | `SERVO_ERROR` | `ERROR` | Servo không phản hồi |
| Lỗi camera | `CAMERA_ERROR` | `ERROR` | Camera không hoạt động |
| Không xác định loại rác | `UNKNOWN_WASTE` | `WARNING` | Không thể xác định loại rác |

Ngưỡng confidence mặc định đề xuất:

```text
70%
```

Ngưỡng này phải có khả năng thay đổi trong cấu hình hệ thống và không nên khẳng định là tối ưu trước khi thử nghiệm.

---

# 13. Luồng nghiệp vụ chính

## 13.1. Luồng phân loại thành công

1. Cảm biến phát hiện vật.
2. Camera chụp ảnh.
3. Mô hình AI trả kết quả.
4. Kết quả có confidence vượt ngưỡng.
5. ESP32 điều khiển servo tương ứng.
6. Cảm biến xác nhận vật đã rơi.
7. ESP32 gửi sự kiện lên Servlet.
8. Servlet xác thực thiết bị.
9. Servlet lưu `waste_events`.
10. Servlet tạo notification thành công.
11. Dashboard cập nhật trong lần polling tiếp theo.

## 13.2. Luồng confidence thấp

1. AI trả confidence dưới ngưỡng.
2. `wasteType` được ghi là `UNKNOWN`.
3. Không kích hoạt servo phân loại hoặc đưa vào ngăn dự phòng.
4. Gửi sự kiện lên server.
5. Server tạo cảnh báo `LOW_CONFIDENCE`.

## 13.3. Luồng mất Internet

1. Thiết bị vẫn nhận diện và điều khiển servo cục bộ.
2. Sự kiện được lưu tạm trong bộ nhớ thiết bị.
3. Thiết bị thử gửi lại sau một khoảng thời gian.
4. Khi mạng phục hồi, gửi lần lượt các sự kiện chưa đồng bộ.
5. Server sử dụng mã định danh sự kiện để tránh lưu trùng nếu chức năng này được triển khai.

## 13.4. Luồng thiết bị offline

1. Server không nhận heartbeat trong thời gian cấu hình.
2. Thiết bị được đánh dấu `OFFLINE`.
3. Tạo notification.
4. Dashboard hiển thị trạng thái đỏ.
5. Khi heartbeat trở lại, trạng thái đổi thành `ONLINE`.

Ngưỡng offline đề xuất:

```text
Không nhận heartbeat trong 60 giây
```

Chu kỳ heartbeat đề xuất:

```text
30 giây
```

---

# 14. Thiết kế giao diện

## 14.1. Phong cách tổng thể

Phong cách:

```text
Eco-Tech Dashboard
```

Đặc điểm:

- Hiện đại.
- Sạch.
- Ít chi tiết trang trí.
- Tập trung vào dữ liệu.
- Mang cảm giác môi trường và công nghệ.
- Dễ chụp ảnh đưa vào bài báo.

## 14.2. Bảng màu chính

| Vai trò | Mã màu |
|---|---|
| Primary | `#166534` |
| Primary hover | `#14532D` |
| Accent | `#0F766E` |
| Sidebar | `#102A23` |
| Sidebar hover | `#1E4539` |
| Background | `#F8FAF9` |
| Surface/Card | `#FFFFFF` |
| Border | `#E2E8F0` |
| Text primary | `#0F172A` |
| Text secondary | `#64748B` |

## 14.3. Màu loại rác

| Loại | Màu đậm | Nền nhạt |
|---|---|---|
| Nhựa | `#2563EB` | `#EFF6FF` |
| Kim loại | `#64748B` | `#F1F5F9` |
| Thủy tinh | `#0891B2` | `#ECFEFF` |
| Không xác định | `#7C3AED` | `#F5F3FF` |

## 14.4. Màu trạng thái

| Trạng thái | Màu |
|---|---|
| Thành công/Online | `#16A34A` |
| Cảnh báo | `#F59E0B` |
| Lỗi/Offline | `#DC2626` |
| Thông tin | `#2563EB` |
| Đang xử lý | `#7C3AED` |

## 14.5. CSS token

```css
:root {
  --primary: #166534;
  --primary-hover: #14532D;
  --accent: #0F766E;

  --sidebar: #102A23;
  --sidebar-hover: #1E4539;

  --background: #F8FAF9;
  --surface: #FFFFFF;
  --border: #E2E8F0;

  --text-primary: #0F172A;
  --text-secondary: #64748B;

  --plastic: #2563EB;
  --metal: #64748B;
  --glass: #0891B2;
  --unknown: #7C3AED;

  --success: #16A34A;
  --warning: #F59E0B;
  --error: #DC2626;
  --info: #2563EB;

  --radius-sm: 8px;
  --radius-md: 12px;
  --radius-lg: 16px;

  --shadow-card: 0 1px 3px rgba(15, 23, 42, 0.08);
}
```

## 14.6. Typography

Font đề xuất:

- Inter.
- Hoặc system font stack để giảm phụ thuộc:

```css
font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
```

Kích thước:

| Thành phần | Cỡ chữ |
|---|---|
| Page title | 28–32 px |
| Section title | 20–24 px |
| Card value | 28–36 px |
| Body | 14–16 px |
| Small label | 12–13 px |

## 14.7. Grid và spacing

- Base spacing: 4 px.
- Khoảng cách phổ biến: 8, 12, 16, 20, 24, 32 px.
- Max content width: 1440 px.
- Sidebar desktop: 240–260 px.
- Header: 64–72 px.
- Card radius: 12 px.
- Không dùng shadow quá mạnh.

---

# 15. Cấu trúc điều hướng

```text
SMART WASTE BIN

- Tổng quan
- Lịch sử phân loại
- Thông báo
- Thiết bị
- Tài khoản
- Đăng xuất
```

## 15.1. Desktop

- Sidebar cố định bên trái.
- Nội dung cuộn bên phải.
- Header hiển thị tên trang và tài khoản.

## 15.2. Tablet

- Sidebar có thể thu gọn.
- Grid card giảm từ 4 cột xuống 2 cột.

## 15.3. Mobile

- Sidebar chuyển thành drawer.
- Card xếp một cột.
- Bảng lịch sử cho phép cuộn ngang.
- Biểu đồ chiếm toàn chiều rộng.

---

# 16. Đặc tả từng màn hình

## 16.1. Trang đăng nhập

### Thành phần

- Logo hoặc icon tái chế.
- Tên sản phẩm.
- Email.
- Mật khẩu.
- Nút đăng nhập.
- Thông báo lỗi.
- Nút hiện/ẩn mật khẩu.

### Validation

- Email không được để trống.
- Mật khẩu không được để trống.
- Thông báo sai tài khoản phải chung chung.
- Không tiết lộ email nào tồn tại.

### Tiêu chí chấp nhận

- Đăng nhập đúng chuyển đến Dashboard.
- Sai thông tin hiển thị lỗi.
- Người đã đăng nhập không quay lại login khi truy cập route bảo vệ.
- Session kết thúc khi đăng xuất.

## 16.2. Dashboard

### Khối trạng thái thiết bị

Hiển thị:

- Tên thiết bị.
- Mã thiết bị.
- Vị trí.
- Online/offline.
- Lần cập nhật gần nhất.

### Thẻ thống kê

- Tổng số.
- Nhựa.
- Kim loại.
- Thủy tinh.
- Không xác định.
- Tỷ lệ thành công.

### Biểu đồ

- Donut chart theo loại rác.
- Line/bar chart theo ngày.

### Danh sách nhanh

- 5 thông báo gần nhất.
- 10 sự kiện gần nhất.

### Empty state

Nếu chưa có dữ liệu:

```text
Chưa có dữ liệu phân loại. Hãy kiểm tra kết nối của thiết bị.
```

## 16.3. Lịch sử phân loại

### Cột dữ liệu

- ID.
- Thời gian.
- Loại rác.
- Confidence.
- Classification time.
- Sorting time.
- Tổng thời gian.
- Kết quả phân luồng.
- Cảm biến xác nhận.
- Hành động xem chi tiết.

### Bộ lọc

- Từ ngày.
- Đến ngày.
- Loại rác.
- Thành công/thất bại.
- Confidence tối thiểu.
- Nút đặt lại.

### Phân trang

- Mặc định 20 bản ghi/trang.
- Có 10/20/50.

## 16.4. Chi tiết sự kiện

Hiển thị:

- Mã sự kiện.
- Thiết bị.
- Loại rác.
- Confidence.
- Thời gian nhận diện.
- Thời gian servo.
- Tổng thời gian.
- Kết quả.
- Trạng thái cảm biến.
- Mã lỗi.
- Payload gốc cho chế độ debug nếu cần.

## 16.5. Trang thông báo

### Tabs

- Tất cả.
- Chưa đọc.
- Cảnh báo.
- Lỗi.

### Hành động

- Đánh dấu đã đọc.
- Đánh dấu tất cả đã đọc.
- Lọc theo thời gian.

## 16.6. Trang thiết bị

Hiển thị:

- Tên.
- Mã thiết bị.
- Vị trí.
- Trạng thái.
- Firmware.
- Last seen.
- Tổng số sự kiện.
- Sự kiện gần nhất.
- RSSI gần nhất.
- Uptime.
- Free heap nếu thiết bị gửi.

Phiên bản đầu không cho chỉnh sửa token trên giao diện.

## 16.7. Trang tài khoản

- Họ tên.
- Email.
- Đổi mật khẩu.
- Đăng xuất khỏi phiên hiện tại.

---

# 17. Thành phần giao diện dùng lại

- App Sidebar.
- Top Header.
- Status Badge.
- Waste Type Badge.
- Statistic Card.
- Notification Item.
- Data Table.
- Filter Bar.
- Empty State.
- Error State.
- Loading Skeleton.
- Pagination.
- Confirm Dialog.
- Detail Modal.
- Toast Notification.
- Chart Card.

Mọi badge phải có cả chữ và màu. Không dùng màu là tín hiệu duy nhất.

---

# 18. Trạng thái giao diện bắt buộc

Mỗi màn hình có dữ liệu phải xử lý:

1. Loading.
2. Success.
3. Empty.
4. Error.
5. Partial data.
6. Offline device.
7. Session expired.

Ví dụ:

### Loading

- Skeleton card.
- Skeleton table row.

### Error

```text
Không thể tải dữ liệu. Vui lòng thử lại.
```

### Device offline

```text
Thiết bị đã không gửi dữ liệu trong hơn 60 giây.
```

---

# 19. Yêu cầu chức năng chi tiết

## FR-01 — Đăng nhập

- Hệ thống cho phép đăng nhập bằng email và mật khẩu.
- Tạo `HttpSession`.
- Session timeout mặc định 30 phút không hoạt động.
- Cookie session dùng `HttpOnly`.
- Dùng `Secure` khi chạy HTTPS.

## FR-02 — Dashboard tổng quan

- Hiển thị dữ liệu của thiết bị mặc định.
- Dữ liệu cập nhật 5 giây/lần.
- Không reload toàn trang.
- Hiển thị timestamp lần cập nhật frontend.

## FR-03 — Trạng thái online/offline

- Thiết bị online khi `last_seen_at` trong giới hạn.
- Offline khi quá 60 giây.
- Trạng thái phải được tính ở backend hoặc job định kỳ.

## FR-04 — Nhận sự kiện IoT

- Endpoint công khai cho thiết bị nhưng yêu cầu token.
- Lưu raw payload để debug nếu cần.
- Trả status code phù hợp.

## FR-05 — Lịch sử

- Phân trang tại server.
- Lọc tại server.
- Không tải toàn bộ database về browser.

## FR-06 — Thông báo

- Sinh tự động từ quy tắc nghiệp vụ.
- Hỗ trợ đánh dấu đã đọc.
- Hiển thị số lượng chưa đọc trên sidebar.

## FR-07 — Biểu đồ

- Dữ liệu thống kê do backend tổng hợp.
- Không để frontend tải toàn bộ sự kiện chỉ để tự tính.
- Có lựa chọn 7 ngày và 30 ngày.

## FR-08 — Chi tiết thiết bị

- Hiển thị heartbeat gần nhất.
- Không hiển thị bí mật.

## FR-09 — Nhật ký lỗi

- Ghi log backend khi API lỗi.
- Không trả stack trace cho client.

## FR-10 — Đồng bộ mất mạng

- API có thể nhận client event id.
- Nếu triển khai retry, server chống ghi trùng bằng unique key.

---

# 20. HTTP status code

| Trường hợp | Status |
|---|---:|
| Thành công | 200 |
| Tạo sự kiện thành công | 201 |
| Dữ liệu sai | 400 |
| Chưa xác thực người dùng | 401 |
| Device token sai | 401 |
| Không có quyền | 403 |
| Không tìm thấy | 404 |
| Trùng sự kiện | 409 |
| Lỗi server | 500 |
| Database tạm thời không khả dụng | 503 |

---

# 21. Yêu cầu phi chức năng

## 21.1. Hiệu năng

- Dashboard tải lần đầu dưới 3 giây trong điều kiện mạng bình thường.
- API summary phản hồi mục tiêu dưới 500 ms.
- API ghi waste event mục tiêu dưới 800 ms.
- Query lịch sử phải có phân trang.
- Không query lặp kiểu N+1.

## 21.2. Khả năng sử dụng

- Người dùng hiểu trạng thái chính trong 5 giây.
- Các nút có label rõ ràng.
- Lỗi có hướng dẫn xử lý.
- Không dùng từ kỹ thuật không cần thiết trên giao diện chính.

## 21.3. Responsive

- Desktop từ 1024 px.
- Tablet từ 768 px.
- Mobile từ 360 px.
- Bảng cho phép cuộn ngang.

## 21.4. Khả năng truy cập

- Contrast đủ rõ.
- Form có label.
- Có focus state.
- Có thể thao tác bằng bàn phím.
- Icon quan trọng có text.
- Không truyền đạt trạng thái chỉ bằng màu.

## 21.5. Độ tin cậy

- Database transaction cho thao tác lưu sự kiện và notification nếu cần.
- Có retry kết nối database hợp lý.
- Không mất chức năng phân loại cục bộ khi website lỗi.
- Ghi log các lỗi quan trọng.

## 21.6. Khả năng mở rộng

- Database hỗ trợ nhiều thiết bị.
- API dùng `device_code`.
- Service và DAO tách biệt.
- Không hard-code một thiết bị trong mọi lớp.

## 21.7. Bảo trì

- Coding convention thống nhất.
- Không đặt SQL trong JSP.
- Không xử lý nghiệp vụ trong JSP.
- Có README cài đặt.
- Có file `.env.example`.

---

# 22. Bảo mật

## 22.1. Bảo mật tài khoản

- Băm mật khẩu bằng BCrypt.
- Không lưu mật khẩu plain text.
- Không log mật khẩu.
- Không trả password hash cho frontend.
- Session cookie HttpOnly.
- Chống session fixation bằng cách tạo session mới sau login.

## 22.2. Bảo mật thiết bị

- Mỗi thiết bị có token riêng.
- Database chỉ lưu hash của token nếu có thể.
- ESP32 không chứa database password.
- ESP32 không chứa Supabase service key.
- Có thể đổi token khi bị lộ.
- Rate limit endpoint IoT.

## 22.3. Bảo mật database

- JDBC credential chỉ tồn tại ở backend.
- Không commit `.env`.
- Dùng SSL khi kết nối Supabase PostgreSQL.
- Tài khoản database nên có quyền tối thiểu cần thiết.

## 22.4. Bảo mật API

- Validate JSON.
- PreparedStatement chống SQL injection.
- Escape output chống XSS.
- CSRF token cho form thay đổi dữ liệu.
- Không trả stack trace.
- Giới hạn kích thước request body.
- Chặn method không hỗ trợ.

## 22.5. Bảo mật camera và dữ liệu

Phiên bản đầu không lưu ảnh mặc định.

Nếu sau này lưu ảnh:

- Chỉ lưu khi cần nghiên cứu lỗi.
- Có chính sách thời gian lưu.
- Tránh chụp khuôn mặt.
- Không public bucket.
- Dùng signed URL.
- Phân quyền truy cập.

---

# 23. Logging và giám sát

## 23.1. Log backend

Ghi:

- Request ID.
- Device code.
- Endpoint.
- Status code.
- Thời gian xử lý.
- Lỗi database.
- Lỗi JSON.
- Lỗi authentication.

Không ghi:

- Mật khẩu.
- Device token đầy đủ.
- Database password.

## 23.2. Mức log

- INFO: sự kiện bình thường.
- WARN: confidence thấp, dữ liệu bất thường.
- ERROR: database lỗi, exception.
- DEBUG: chỉ bật khi phát triển.

## 23.3. Audit đơn giản

Có thể lưu:

- Người dùng đăng nhập.
- Đánh dấu thông báo đã đọc.
- Thay đổi thông tin thiết bị.

Không bắt buộc ở MVP.

---

# 24. Xử lý lỗi

## 24.1. Lỗi từ ESP32

- JSON thiếu trường.
- Loại rác không hợp lệ.
- Confidence ngoài khoảng.
- Token sai.
- Request trùng.
- Payload quá lớn.

## 24.2. Lỗi database

- Timeout.
- Mất kết nối.
- Constraint violation.
- Transaction thất bại.

## 24.3. Lỗi frontend

- API không phản hồi.
- Session hết hạn.
- Dữ liệu biểu đồ rỗng.
- Mất mạng trình duyệt.

## 24.4. Nguyên tắc

- Hiển thị thông báo thân thiện cho người dùng.
- Log chi tiết cho developer.
- Không hiển thị stack trace ra UI.
- Cho phép thử lại khi lỗi tạm thời.

---

# 25. Kiểm thử

## 25.1. Unit test

- Validation waste type.
- Validation confidence.
- Tính success rate.
- Tính online/offline.
- Notification rule.
- Password hashing.

## 25.2. Integration test

- Servlet → Service → DAO → PostgreSQL.
- API POST waste event.
- Login session.
- Query phân trang.
- Mark notification read.

## 25.3. API test

Các trường hợp:

- Request hợp lệ.
- Token sai.
- Thiếu loại rác.
- Confidence âm.
- Waste type không hỗ trợ.
- Database lỗi.
- Duplicate client event id.

## 25.4. UI test

- Desktop.
- Tablet.
- Mobile.
- Bảng dài.
- Dữ liệu rỗng.
- Device offline.
- Session expired.
- Biểu đồ không có dữ liệu.

## 25.5. Kiểm thử thực tế với thiết bị

- ESP32 gửi JSON thành công.
- Server trả 201.
- Sự kiện xuất hiện trên dashboard.
- Dashboard cập nhật trong tối đa 5 giây.
- Mất Wi-Fi và kết nối lại.
- Gửi nhiều sự kiện liên tiếp.
- Confidence thấp.
- Servo thất bại.
- Heartbeat dừng và trạng thái offline xuất hiện.

---

# 26. Dữ liệu phục vụ bài báo

Website phải giúp lấy được các chỉ số:

- Tổng số mẫu thử.
- Số mẫu theo từng loại.
- Số lần nhận diện đúng.
- Số lần nhận diện sai.
- Số lần phân luồng đúng.
- Số lần phân luồng sai.
- Confidence trung bình.
- Thời gian xử lý trung bình.
- Thời gian nhận diện trung bình.
- Thời gian servo trung bình.
- Tỷ lệ gửi dữ liệu thành công.
- Tỷ lệ thiết bị online.
- Số lỗi kết nối.
- Số lần `UNKNOWN`.

Các chỉ số này có thể dùng để xây dựng bảng kết quả và biểu đồ trong bài báo.

---

# 27. Quy tắc tính toán

## 27.1. Tổng số sự kiện

```text
COUNT(waste_events.id)
```

## 27.2. Số lượng từng loại

```text
COUNT(*) WHERE waste_type = 'PLASTIC'
COUNT(*) WHERE waste_type = 'METAL'
COUNT(*) WHERE waste_type = 'GLASS'
```

## 27.3. Tỷ lệ phân luồng thành công

```text
successful sorting events / total sorting events × 100%
```

## 27.4. Thời gian xử lý trung bình

```text
AVG(total_processing_time_ms)
```

## 27.5. Trạng thái online

```text
NOW() - last_seen_at <= 60 seconds
```

## 27.6. Confidence thấp

```text
confidence < configured threshold
```

---

# 28. Deployment

## 28.1. Development

- Java 17.
- Maven.
- Tomcat local.
- Supabase project.
- File environment local.
- Browser Chrome/Edge.

## 28.2. Biến môi trường

```text
DB_URL
DB_USER
DB_PASSWORD
DB_SSL_MODE
APP_ENV
SESSION_TIMEOUT_MINUTES
DEVICE_OFFLINE_SECONDS
LOW_CONFIDENCE_THRESHOLD
```

## 28.3. Build

```bash
mvn clean test package
```

Kết quả:

```text
target/smart-waste-bin.war
```

## 28.4. Deploy Tomcat

- Đưa WAR vào `webapps`.
- Cấu hình environment.
- Khởi động Tomcat.
- Kiểm tra log.
- Kiểm tra health endpoint.

## 28.5. Health endpoint

```http
GET /api/health
```

Response:

```json
{
  "status": "UP",
  "database": "UP"
}
```

## 28.6. Khuyến nghị hosting

Yêu cầu:

- Hỗ trợ Java/Tomcat hoặc Docker.
- Có HTTPS.
- Cho phép outbound PostgreSQL.
- Không sleep quá nhanh nếu cần nhận ESP32 liên tục.

Không được hard-code lựa chọn nhà cung cấp vào kiến trúc cốt lõi.

---

# 29. Kế hoạch triển khai theo giai đoạn

## Giai đoạn 1 — Khung dự án

- Tạo Maven project.
- Kết nối Tomcat.
- Tạo layout JSP.
- Tạo database.
- Viết config JDBC.

## Giai đoạn 2 — Xác thực

- Users table.
- Login Servlet.
- Session filter.
- Logout.

## Giai đoạn 3 — API IoT

- Device authentication.
- Waste event endpoint.
- Heartbeat endpoint.
- Validation.
- Logging.

## Giai đoạn 4 — Dashboard

- Summary API.
- Statistic cards.
- Device status.
- Polling.

## Giai đoạn 5 — Lịch sử và thông báo

- Bảng lịch sử.
- Filter.
- Pagination.
- Notification page.
- Mark read.

## Giai đoạn 6 — Biểu đồ

- By type.
- By day.
- Success rate.

## Giai đoạn 7 — Tích hợp thiết bị

- ESP32 gửi thật.
- Xử lý mất mạng.
- Test heartbeat.
- Test token.

## Giai đoạn 8 — Hoàn thiện

- Responsive.
- Security review.
- Test.
- Tạo dữ liệu thực nghiệm.
- Chụp màn hình cho bài báo.

---

# 30. Mức ưu tiên MoSCoW

## Must have

- Login.
- Dashboard.
- Nhận dữ liệu ESP32.
- Lưu Supabase PostgreSQL.
- Lịch sử.
- Thống kê ba loại rác.
- Trạng thái online/offline.
- Thông báo lỗi cơ bản.
- Bảo mật device token.
- Responsive desktop/tablet.

## Should have

- Biểu đồ 7 ngày.
- Confidence.
- Thời gian xử lý.
- Mark notification read.
- Heartbeat.
- Chi tiết sự kiện.
- Empty/error/loading state.

## Could have

- CSV export.
- Nhiều thiết bị.
- WebSocket.
- Ảnh nhận diện sai.
- Điều khiển từ xa.
- Vai trò người dùng.

## Won't have trong v1

- Mobile native.
- GPS.
- Thanh toán.
- Quản lý xe thu gom.
- AI training trên website.
- Video streaming.

---

# 31. Tiêu chí nghiệm thu tổng thể

Sản phẩm được xem là đạt MVP khi:

1. Quản trị viên đăng nhập được.
2. ESP32 gửi được ít nhất một sự kiện thật lên Servlet.
3. Servlet xác thực thiết bị thành công.
4. Dữ liệu được lưu trong Supabase PostgreSQL.
5. Dashboard hiển thị đúng tổng số.
6. Dashboard phân biệt đúng nhựa, kim loại và thủy tinh.
7. Lịch sử hiển thị được sự kiện mới.
8. Thiết bị hiển thị online khi có heartbeat.
9. Thiết bị chuyển offline khi quá ngưỡng.
10. Thông báo được sinh khi confidence thấp hoặc phân luồng thất bại.
11. Giao diện hoạt động trên desktop và tablet.
12. Không lộ database credential hoặc Supabase secret trên frontend.
13. Mọi query đầu vào dùng PreparedStatement.
14. Mật khẩu tài khoản được băm.
15. Hệ thống có dữ liệu đủ để tạo ít nhất hai biểu đồ phục vụ bài báo.

---

# 32. Quyết định kỹ thuật đã chốt

- Phân loại ba nhóm: nhựa, kim loại, thủy tinh.
- Java Servlet là backend chính.
- JSP là view layer.
- Supabase PostgreSQL là cloud database.
- ESP32 gửi dữ liệu bằng Wi-Fi và HTTP JSON.
- Dashboard dùng giao diện Eco-Tech.
- Primary color là xanh lá.
- Nhựa dùng xanh dương.
- Kim loại dùng xám.
- Thủy tinh dùng cyan.
- Website ưu tiên giám sát, không ưu tiên điều khiển.
- Phiên bản đầu không lưu ảnh mặc định.
- Thiết bị vẫn phải phân loại khi mất Internet.
- Website dùng polling trước, realtime nâng cấp sau.

---

# 33. Các vấn đề chưa chốt

Nhóm cần xác nhận trong quá trình tiếp theo:

1. Mô hình AI chạy trên ESP32-CAM hay server.
2. ESP32-CAM gửi nhãn hay gửi ảnh.
3. Vai trò chính xác của Arduino Uno.
4. Có cảm biến xác nhận rác rơi đúng ngăn hay không.
5. Có cảm biến mức đầy hay không.
6. Confidence được biểu diễn từ 0–1 hay 0–100.
7. Chu kỳ heartbeat.
8. Ngưỡng xác định offline.
9. Ngưỡng confidence thấp.
10. Có ngăn `UNKNOWN` hay giữ vật ở khu vực chờ.
11. Có cần lưu raw payload.
12. Có cần client event id để chống trùng.
13. Hosting Java Servlet được sử dụng.
14. Phiên bản Tomcat và package `jakarta` hay `javax`.
15. Số lượng thiết bị trong lần demo.

---

# 34. Rủi ro và phương án giảm thiểu

| Rủi ro | Tác động | Giảm thiểu |
|---|---|---|
| ESP32 mất Wi-Fi | Mất dữ liệu cloud | Lưu tạm và gửi lại |
| Supabase tạm lỗi | Không ghi được dữ liệu | Retry có giới hạn, log lỗi |
| Servlet không public | ESP32 không gọi được | Deploy cloud hoặc dùng tunnel demo |
| Token bị lộ | Giả mạo thiết bị | Token riêng, rotate token, HTTPS |
| Dữ liệu trùng khi retry | Thống kê sai | Client event id + unique constraint |
| Confidence thấp | Phân loại sai | Ngưỡng và trạng thái UNKNOWN |
| Servo lỗi | Rác sai ngăn | Sensor confirmation + notification |
| Giao diện quá nhiều chức năng | Chậm tiến độ | Bám MVP |
| Lưu ảnh quá nhiều | Tốn storage, riêng tư | Không lưu ảnh mặc định |
| Trộn Jakarta và Javax | Lỗi deploy | Chốt Tomcat từ đầu |
| Kết nối JDBC Supabase sai | Backend không chạy | Test connection sớm |
| Không đủ dữ liệu thực nghiệm | Bài báo yếu | Lập kế hoạch test từ đầu |

---

# 35. Định nghĩa hoàn thành — Definition of Done

Một chức năng chỉ được xem là hoàn thành khi:

- Code chạy được.
- Có validation.
- Có xử lý lỗi.
- Có log phù hợp.
- Có test tối thiểu.
- Không lộ secret.
- Giao diện có loading/empty/error.
- Responsive ở kích thước mục tiêu.
- Được kiểm thử với dữ liệu thật hoặc dữ liệu mock xác thực.
- Tài liệu API được cập nhật.
- Không còn TODO quan trọng trong luồng chính.

---

# 36. Kết luận

Website Smart Waste Bin IoT Dashboard được định hướng là một hệ thống giám sát nhỏ nhưng đầy đủ về mặt kiến trúc. Sản phẩm kết hợp lớp thiết bị IoT, giao tiếp Wi-Fi/HTTP, backend Java Servlet, cơ sở dữ liệu Supabase PostgreSQL và giao diện JSP/JavaScript.

Thiết kế ưu tiên khả năng triển khai thực tế trong phạm vi môn học, đồng thời vẫn tạo ra đủ dữ liệu để phục vụ bài báo. Phiên bản đầu không cần quá nhiều chức năng quản trị phức tạp. Giá trị quan trọng nhất là chứng minh được một chu trình hoàn chỉnh:

```text
Thiết bị vật lý
→ Nhận diện và phân loại
→ Truyền dữ liệu qua Internet
→ Backend xử lý
→ Database lưu trữ
→ Website trực quan hóa
```

PRD này là tài liệu nền để tiếp tục xây dựng ERD, API specification, wireframe, database script, code Servlet và kế hoạch kiểm thử chi tiết.
