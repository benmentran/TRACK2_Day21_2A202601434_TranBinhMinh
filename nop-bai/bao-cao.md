# Báo Cáo Lab Day 21 - CI/CD cho AI Systems

| | |
|---|---|
| Họ và tên | Tran Binh Minh |
| MSSV | 2A202601434 |
| Lớp / Khóa | K4 |
| Repo GitHub | https://github.com/benmentran/TRACK2_Day21_2A202601434_TranBinhMinh |
| Ngày nộp | 2026-08-21 |

---

## 1. Bộ Siêu Tham Số Đã Chọn và Lý Do

| Lần chạy | n_estimators | learning_rate | max_depth | f1_score | accuracy |
|---|---|---|---|---|---|
| 1 | 150 | 0.15 | 4 | 0.7182 | 0.876 |
| 2 | 200 | 0.10 | 5 | 0.7149 | 0.874 |
| 3 | 100 | 0.10 | 3 | 0.7109 | 0.878 |

**Bộ siêu tham số đã chọn:** `n_estimators=150`, `learning_rate=0.15`, `max_depth=4`.

**Lý do:** Bộ siêu tham số này đạt f1_score cao nhất (0.7182) trong số các lần chạy. Mặc dù lần chạy thứ 3 có accuracy cao nhất (0.878), nhưng f1_score chỉ đạt 0.7109, cho thấy mô hình thiên về dự đoán lớp đa số. F1_score đo lường sự cân bằng giữa precision và recall, quan trọng hơn accuracy trong bài toán phân loại không cân bằng. Có sự đánh đổi giữa n_estimators và learning_rate: learning_rate cao hơn (0.15) kết hợp n_estimators vừa phải (150) cho kết quả tốt hơn learning_rate thấp (0.05) với n_estimators cao (300), vì learning_rate cao giúp mô hình hội tụ nhanh hơn.

---

## 2. Vì Sao Ngưỡng Chất Lượng Đặt Trên F1 Chứ Không Phải Accuracy

Tập dữ liệu có khoảng 24% mẫu thuộc lớp thu nhập cao (>50K) và 76% thuộc lớp thu nhập thấp. Nếu một mô hình luôn dự đoán "thu nhập thấp", nó sẽ đạt accuracy khoảng 76%, nhưng hoàn toàn không phát hiện được lớp thu nhập cao, khiến accuracy trở thành chỉ số gây hiểu nhầm. F1_score của lớp dương (thu nhập cao) đo lường precision (tỷ lệ dự đoán đúng trong số các dự đoán thu nhập cao) và recall (tỷ lệ phát hiện đúng các mẫu thu nhập cao thực sự). F1_score phản ánh khả năng thực sự của mô hình trong việc phân biệt hai lớp, trong khi accuracy chỉ đơn thuần đếm số dự đoán đúng, thiên vị lớp đa số. Khi gọi f1_score, không sử dụng average="weighted" hay average="macro" vì chúng sẽ gộp cả hai lớp lại, trong khi ta chỉ quan tâm đến hiệu suất dự đoán lớp dương (thu nhập cao),也就是 lớp quan trọng nhất trong bài toán này.

---

## 3. Khó Khăn Gặp Phải và Cách Giải Quyết

| Khó khăn | Nguyên nhân | Cách giải quyết |
|---|---|---|
| DVC pull thất bại trong CI | File dữ liệu mới không được push đúng cách qua DVC remote | Sử dụng VM có DVC cài sẵn để thực hiện `dvc add` + `dvc push` đúng quy trình |
| SA key bị từ chối | Tổ chức GCP có chính sách `iam.disableServiceAccountKeyCreation` | Sử dụng file ADC (authorized_user) thay vì service account key |
| scikit-learn version mismatch | VM có sklearn 1.6.x trong khi CI cần 1.4.2 | Ghim scikit-learn==1.4.2 trong requirements.txt và cài trên VM |

---

## 4. So Sánh Bước 2 và Bước 3 (bắt buộc, 2 - 3 câu)

| | f1_score | accuracy |
|---|---|---|
| Bước 2 (chỉ `train_batch1`) | 0.7182 | 0.876 |
| Bước 3 (thêm `train_batch2`) | 0.7297 | 0.880 |

**Nhận xét:** F1_score tăng nhẹ từ 0.7182 lên 0.7297 (+0.0115) khi thêm 22361 mẫu dữ liệu mới. Accuracy cũng cải thiện từ 0.876 lên 0.880. Mức tăng khiêm tốn vì dữ liệu mới cùng phân phối với dữ liệu gốc, không mang thêm thông tin phân biệt mới. Điều này phù hợp với kỳ vọng: thêm dữ liệu cùng phân bố giúp mô hình học tốt hơn nhưng không tạo ra bước đột phá về hiệu suất.

---


