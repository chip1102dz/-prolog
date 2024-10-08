:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/html_write)).
:- set_prolog_flag(encoding, utf8).
:- encoding(utf8).
%Cong sever
server_port(3000).


:- http_handler(root(.), handle_get_request, []). % Thiet lap yeu cau GET
:- http_handler(root(submit), handle_post_request, []). % Thiet lap yeu cau POST

% Khoi dong sever
start_server :-
    server_port(Port),
    http_server(http_dispatch, [port(Port)]).

% Xu ly yeu cau GET
handle_get_request(_Request) :-
    reply_html_page(
        title('Hệ chuyên gia thể hình'),
        [h2('Huấn luyện viên thể hình'), \form_content,
        style('
		
        body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        color: #333;
        }

        h2 {
            color: #0066cc;
        }

        form {
            max-width: 400px;
            margin: 20px auto;
            padding: 15px;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        label {
            display: block;
            margin-bottom: 8px;
        }

        input, select {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            box-sizing: border-box;
        }

        input[type="submit"] {
            background-color: #0066cc;
            color: #fff;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #0052a3;
        }

        select {
            background-color: #fff;
            color: #333;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        option {
            background-color: #fff;
            color: #333;
        }
         ')]
    ).

% Xu ly yeu cau post
handle_post_request(Request) :-
    http_parameters(Request, [fullname(Fullname, []), age(Age, []), gender(Gender, []), height(Height, []), weight(Weight, []), goal(Goal, []), level(Level, []), type(Type, []), facility(Facility, []), time(Time, [])]),
    generate_fitness_program(Fullname, Age, Gender, Height, Weight, Goal, Level, Type, Facility, Time, Program),
    reply_html_page(
    title('Hệ chuyên gia thể hình'),
    [h2('Bảng hướng dẫn tập thể hình'),
    style('
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            color: #333;
            margin: 0;
            padding: 0;
        }

        h2 {
            color: #0066cc;
            text-align: center;
            margin-top: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 15px;
            text-align: left;
            border: 1px solid #ddd;
            border-radius: 5px; /* Bo góc cho ô */
        }

        th {
            background-color: #0066cc;
            color: white;
            font-size: 1.1em; /* Tăng kích thước chữ cho tiêu đề */
        }

        tr:nth-child(even) {
            background-color: #f9f9f9; /* Màu nền cho các hàng chẵn */
        }

        tr:hover {
            background-color: #e0e0e0; /* Màu nền khi hover */
        }

        p {
            display: inline-block;
            margin-right: 10px;
            font-size: 1.1em; /* Tăng kích thước chữ cho thông tin cá nhân */
        }
		'),
		p('Họ tên: ~w' - [Fullname]),
		p('Tuổi: ~w' - [Age]),
		p('Giới tính: ~w' - [Gender]),
		p('Chiều cao (cm): ~w' - [Height]),
		p('Cân nặng (kg): ~w' - [Weight]),
		p('Mục tiêu: ~w' - [Goal]),
		p('Trình độ: ~w' - [Level]),
		p('Chương trình tập: ~w' - [Type]),
		p('Địa điểm tập: ~w' - [Facility]),
		p('Thời gian: ~w' - [Time]),
		\fitness_program_table(Program)]
	).


%Program1: Nam, Tăng cân, người mới, toàn thân, tại phòng gym, 4 ngay
generate_fitness_program(Fullname, Age, he, Height, Weight, tangcan, Level, fullbody, gym, bon, Program) :-
    Program = [
		exercise('Thứ 2','Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).','Sáng: Bánh mì sandwich trứng ốp la với phô mai và rau xà lách, sinh tố chuối bơ.'),
		exercise('','Squat (Gánh tạ): 3 hiệp x 8-12 lần - Phát triển cơ đùi trước, đùi sau, mông và tăng cường sức mạnh cơ core.','Trưa: Cơm gạo lứt, thịt bò xào rau củ, canh rau.'),
		exercise('', 'Bench Press (Nằm đẩy tạ đòn): 3 hiệp x 8-12 lần - Phát triển cơ ngực, vai trước và cơ tam đầu.', 'Phụ: Sữa chua Hy Lạp, trái cây, các loại hạt.'),
		exercise('','Barbell Row (Chèo tạ đòn): 3 hiệp x 8-12 lần - Phát triển cơ lưng xô, cơ cầu vai sau, cơ bắp tay trước và tăng cường sức mạnh cơ core.','Tối: Gà nướng mật ong, khoai lang luộc, salad rau trộn.'),
		exercise('','Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 30-60 giây - Tăng cường sức mạnh cơ core, cải thiện tư thế và ổn định cột sống.', ''),
		exercise('','Kết thúc buổi tập bằng giãn cơ tĩnh (5-10 phút).',''),

		exercise('Thứ 3','Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).','Sáng: Yến mạch với sữa tươi, hoa quả và hạt.'),
		exercise('','Deadlift (Nâng tạ đất): 3 hiệp x 8-10 lần - Bài tập compound tác động lên hầu hết các nhóm cơ chính trên cơ thể.','Trưa: Cơm gạo lứt, cá hồi nướng, rau củ luộc.'),
		exercise('','Dumbbell Lunges (Chùng chân với tạ đơn): 3 hiệp x 8-12 lần mỗi chân - Phát triển cơ đùi trước, đùi sau, mông và cải thiện sự cân bằng.','Phụ: Sinh tố whey protein, trái cây sấy khô.'),
		exercise('','Dips (Chống đẩy trên xà kép): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực dưới, cơ tam đầu, cơ vai trước.','Tối: Mì ý sốt thịt bằm, salad cà chua dưa chuột.'),
		exercise('','Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng, đặc biệt là cơ bụng trên.',''),
		exercise('','Kết thúc buổi tập bằng giãn cơ tĩnh (5-10 phút).',''),
		exercise('Thứ 4','Nghỉ ngơi',''),
		
		exercise('Thứ 5','Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).','Sáng: Bánh mì nguyên cái kẹp thịt nguội và rau củ, sữa chua.'),
		exercise('','Barbell Hip Thrust (Đẩy hông với tạ đòn): 3 hiệp x 8-12 lần - Phát triển cơ mông, cơ đùi sau, cơ lưng dưới.','Trưa: Cơm gạo lứt, thịt heo luộc, canh bí đỏ.'),
		exercise('','Dumbbell Row (Chèo tạ đơn): 3 hiệp x 8-12 lần mỗi tay - Phát triển cơ lưng xô, cơ bắp tay trước.','Phụ: Chuối, các loại hạt.'),
		exercise('','Lateral Raises (Nâng tạ đơn sang ngang): 3 hiệp x 10-15 lần - Phát triển cơ vai giữa, tạo dáng vai rộng hơn.','Tối: Súp gà nấm, bánh mì nướng.'),
		exercise('','Leg Raises (Nâng chân): 3 hiệp x 15-20 lần - Phát triển cơ bụng dưới.',''),
		exercise('','Kết thúc buổi tập bằng giãn cơ tĩnh (5-10 phút).',''),
		
		exercise('Thứ 6','Nghỉ ngơi',''),
		exercise('Thứ 7','Nghỉ ngơi',''),
		exercise('Chủ nhật','Nghỉ ngơi','')
    ].

%Program2: Nam, Tăng cân, người mới, toàn thân, tại phòng gym, 5 ngay
generate_fitness_program(Fullname, Age, he, Height, Weight, tangcan, Level, fullbody, gym, nam, Program) :-
    Program = [
        exercise('Thứ 2', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì sandwich trứng ốp la với phô mai và rau xà lách, sinh tố chuối bơ.'),
		exercise('', 'Squat (Gánh tạ): 3 hiệp x 8-12 lần - Phát triển cơ đùi trước, đùi sau, mông và tăng cường sức mạnh cơ core.', 'Trưa: Cơm gạo lứt, thịt bò xào rau củ, canh rau.'),
		exercise('', 'Bench Press (Nằm đẩy tạ đòn): 3 hiệp x 8-12 lần - Phát triển cơ ngực, vai trước và cơ tam đầu.', 'Phụ: Sữa chua Hy Lạp, trái cây, các loại hạt.'),
		exercise('', 'Barbell Row (Chèo tạ đòn): 3 hiệp x 8-12 lần - Phát triển cơ lưng xô, cơ cầu vai sau, cơ bắp tay trước và tăng cường sức mạnh cơ core.', 'Tối: Gà nướng mật ong, khoai lang luộc, salad rau trộn.'),
		exercise('', 'Overhead Press (Đẩy tạ đơn qua đầu): 3 hiệp x 8-12 lần - Phát triển cơ vai, cơ tam đầu và tăng cường sức mạnh cơ core.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 30-60 giây - Tăng cường sức mạnh cơ core, cải thiện tư thế và ổn định cột sống.', ''),
		exercise('', 'Kết thúc buổi tập bằng giãn cơ tĩnh (5-10 phút).', ''),
		
		
		exercise('Thứ 3', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Yến mạch với sữa tươi, hoa quả và hạt.'),
		exercise('', 'Deadlift (Nâng tạ đất): 1 hiệp x 5 lần - Bài tập compound tác động lên hầu hết các nhóm cơ chính trên cơ thể, đặc biệt là cơ lưng dưới, cơ mông, cơ đùi sau.', 'Trưa: Cơm gạo lứt, cá hồi nướng, rau củ luộc.'),
		exercise('', 'Pull-up (Kéo xà đơn): 3 hiệp, tối đa số lần có thể - Phát triển cơ lưng xô, cơ bắp tay trước, cơ vai sau', 'Phụ: Sinh tố whey protein, trái cây sấy khô.'),
		exercise('', 'Dumbbell Lunges (Chùng chân với tạ đơn): 3 hiệp x 8-12 lần mỗi chân - Phát triển cơ đùi trước, đùi sau, mông và cải thiện sự cân bằng.', 'Tối: Mì ý sốt thịt bằm, salad cà chua dưa chuột.'),
		exercise('', 'Dumbbell Shoulder Press (Đẩy tạ đơn qua đầu): 3 hiệp x 8-12 lần mỗi tay - Phát triển cơ vai, cơ tam đầu.', ''),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng, đặc biệt là cơ bụng trên.', ''),
		exercise('', 'Kết thúc buổi tập bằng giãn cơ tĩnh (5-10 phút).', ''),
		
		exercise('Thứ 4', 'Nghỉ ngơi', ''),
		
		exercise('Thứ 5', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cái kẹp thịt nguội và rau củ, sữa chua.'),
		exercise('', 'Barbell Hip Thrust (Đẩy hông với tạ đòn): 3 hiệp x 8-12 lần - Phát triển cơ mông, cơ đùi sau, cơ lưng dưới.', 'Trưa: Cơm gạo lứt, thịt heo luộc, canh bí đỏ.'),
		exercise('', 'Dips (Chống đẩy trên xà kép): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực dưới, cơ tam đầu, cơ vai trước.', 'Phụ: Chuối, các loại hạt.'),
		exercise('', 'Dumbbell Row (Chèo tạ đơn): 3 hiệp x 8-12 lần mỗi tay - Phát triển cơ lưng xô, cơ bắp tay trước.', 'Tối: Súp gà nấm, bánh mì nướng.'),
		exercise('', 'Lateral Raises (Nâng tạ đơn sang ngang): 3 hiệp x 10-15 lần - Phát triển cơ vai giữa, tạo dáng vai rộng hơn.', ''),
		exercise('', 'Leg Raises (Nâng chân): 3 hiệp x 15-20 lần - Phát triển cơ bụng dưới.', ''),
		exercise('', 'Kết thúc buổi tập bằng giãn cơ tĩnh (5-10 phút).', ''),
		
		exercise('Thứ 6', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cái kẹp thịt nguội và rau củ, sữa chua.'),
		exercise('', 'Romanian Deadlift (Nâng tạ kiểu Romanian): 3 hiệp x 10-15 lần - Phát triển cơ đùi sau, cơ mông.', 'Trưa: Cơm gạo lứt, thịt heo luộc, canh bí đỏ.'),
		exercise('', 'Overhead Press (Đẩy tạ đơn qua đầu): 3 hiệp x 8-12 lần - Phát triển cơ vai, cơ tam đầu.', 'Phụ: Chuối, các loại hạt.'),
		exercise('', 'Lat Pulldown (Kéo xà đơn): 3 hiệp x 10-15 lần - Phát triển cơ lưng xô.', 'Tối: Súp gà nấm, bánh mì nướng.'),
		exercise('', 'Dumbbell Bicep Curls (Cuốn tạ đơn): 3 hiệp x 10-15 lần - Phát triển cơ bắp tay trước.', ''),
		exercise('', 'Reverse Crunches (Gập bụng ngược): 3 hiệp x 15-20 lần - Phát triển cơ bụng dưới.', ''),
		exercise('', 'Kết thúc buổi tập bằng giãn cơ tĩnh (5-10 phút).', ''),
		
		exercise('Thứ 7', 'Nghỉ ngơi', ''),
		exercise('Chủ nhật', 'Nghỉ ngơi', '')
    ].

%Program3: Nam, Tăng cân, người mới, toàn thân, tại phòng gym, 6 ngày
generate_fitness_program(Fullname, Age, he, Height, Weight, tangcan, Level, fullbody, gym, sau, Program) :-
    Program = [
		exercise('Thứ 2', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì sandwich trứng ốp la với phô mai và rau xà lách, sinh tố chuối bơ.'),
		exercise('', 'Barbell Back Squat (Gánh tạ đòn sau): 3 hiệp x 8-12 lần - Phát triển cơ đùi trước, đùi sau, mông.', 'Trưa: Cơm gạo lứt, thịt bò xào rau củ, canh rau.'),
		exercise('', 'Leg Press (Đạp tạ chân): 3 hiệp x 10-15 lần - Phát triển cơ đùi trước và mông.', 'Chiều: Sữa chua Hy Lạp, trái cây, các loại hạt.'),
		exercise('', 'Hamstring Curls (Cuốn tạ đùi sau): 3 hiệp x 12-15 lần - Phát triển cơ đùi sau.', 'Tối: Gà nướng mật ong, khoai lang luộc, salad rau trộn.'),
		exercise('', 'Standing Calf Raises (Nhón bắp chuối đứng): 3 hiệp x 15-20 lần - Phát triển cơ bắp chân.', ''),
		exercise('', 'Overhead Press (Đẩy tạ đơn qua đầu): 3 hiệp x 8-12 lần - Phát triển cơ vai.', ''),
		exercise('', 'Lateral Raises (Nâng tạ đơn sang ngang): 3 hiệp x 12-15 lần - Phát triển cơ vai giữa.', ''),
		exercise('', 'Front Raises (Nâng tạ đơn trước mặt): 3 hiệp x 12-15 lần - Phát triển cơ vai trước.', ''),
		
		exercise('Thứ 3', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Yến mạch với sữa tươi, hoa quả và hạt.'),
		exercise('', 'Barbell Bench Press (Nằm đẩy tạ đòn): 3 hiệp x 8-12 lần - Phát triển cơ ngực, vai trước và cơ tam đầu.', 'Trưa: Cơm gạo lứt, cá hồi nướng, rau củ luộc.'),
		exercise('', 'Incline Dumbbell Press (Nằm đẩy tạ đơn trên ghế dốc): 3 hiệp x 10-15 lần - Phát triển cơ ngực trên.', 'Chiều: Sinh tố whey protein, trái cây sấy khô.'),
		exercise('', 'Dips (Chống đẩy trên xà kép): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực dưới, cơ tam đầu.', 'Tối: Mì ý sốt thịt bằm, salad cà chua dưa chuột.'),
		exercise('', 'Triceps Pushdowns (Đẩy tạ dây cáp xuống): 3 hiệp x 12-15 lần - Phát triển cơ tay sau.', ''),
		exercise('', 'Overhead Dumbbell Extensions (Duỗi tạ đơn qua đầu): 3 hiệp x 12-15 lần - Phát triển cơ tay sau.', ''),

		exercise('Thứ 4', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cám kẹp thịt nguội và rau củ, sữa chua.'),
		exercise('', 'Pull-ups (Kéo xà đơn): 3 hiệp, tối đa số lần có thể - Phát triển cơ lưng xô, cơ bắp tay trước.', 'Trưa: Cơm gạo lứt, thịt heo luộc, canh bí đỏ.'),
		exercise('', 'Barbell Row (Chèo tạ đòn): 3 hiệp x 8-12 lần - Phát triển cơ lưng xô.', 'Chiều: Chuối, các loại hạt.'),
		exercise('', 'Lat Pulldowns (Kéo xà lat): 3 hiệp x 10-15 lần - Phát triển cơ lưng xô.', 'Tối: Súp gà nấm, bánh mì nướng.'),
		exercise('', 'Seated Cable Rows (Chèo cáp ngồi): 3 hiệp x 12-15 lần - Phát triển cơ lưng giữa.', ''),
		exercise('', 'Barbell Curls (Cuốn tạ đòn): 3 hiệp x 8-12 lần - Phát triển cơ tay trước.', ''),
		exercise('', 'Dumbbell Hammer Curls (Cuốn tạ đơn kiểu búa): 3 hiệp x 10-15 lần - Phát triển cơ tay trước và cơ cẳng tay.', ''),
		
		exercise('Thứ 5', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Trứng chiên rau củ, ngũ cốc granola với sữa.'),
		exercise('', 'Romanian Deadlifts (Nâng tạ kiểu Romanian): 3 hiệp x 10-15 lần - Phát triển cơ đùi sau, mông.', 'Trưa: Cơm gạo lứt, cá kho tộ, rau luộc.'),
		exercise('', 'Leg Extensions (Duỗi chân): 3 hiệp x 12-15 lần - Phát triển cơ đùi trước.', 'Chiều: Bánh protein, sữa đậu nành.'),
		exercise('', 'Calf Raises on the Leg Press Machine (Nhón bắp chuối trên máy đạp chân): 3 hiệp x 15-20 lần - Phát triển cơ bắp chân.', 'Tối: Thịt bò bít tết, khoai tây nghiền, salad.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng trên.', ''),
		exercise('', 'Leg Raises (Nâng chân): 3 hiệp x 15-20 lần - Phát triển cơ bụng dưới.', ''),
		exercise('', 'Russian Twists (Xoay người với tạ): 3 hiệp x 15-20 lần mỗi bên - Phát triển cơ bụng chéo.', ''),
		
		exercise('Thứ 6', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Cháo gà, trứng luộc.'),
		exercise('', 'Dumbbell Lunges (Chùng chân với tạ đơn): 2 hiệp x 10-12 lần mỗi chân - Phát triển cơ đùi trước, đùi sau, mông.', 'Trưa: Cơm gạo lứt, cá thu rim, canh chua.'),
		exercise('', 'Dumbbell Bench Press (Nằm đẩy tạ đơn): 2 hiệp x 10-12 lần - Phát triển cơ ngực.', 'Chiều: Trái cây, sữa chua.'),
		exercise('', 'Dumbbell Row (Chèo tạ đơn): 2 hiệp x 10-12 lần mỗi tay - Phát triển cơ lưng.', 'Tối: Bún thịt nướng, rau sống.'),
		exercise('', 'Plank (Chống đẩy tĩnh): 2 hiệp, giữ tối đa 30-60 giây - Tăng cường sức mạnh cơ core.', ''),
		
		exercise('Thứ 7', 'Nghỉ ngơi', ''),
		
		exercise('Chủ nhật','Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).','Sáng: Yến mạch với sữa tươi, hoa quả và hạt.'),
		exercise('','Deadlift (Nâng tạ đất): 3 hiệp x 8-10 lần - Bài tập compound tác động lên hầu hết các nhóm cơ chính trên cơ thể.','Trưa: Cơm gạo lứt, cá hồi nướng, rau củ luộc.'),
		exercise('','Dumbbell Lunges (Chùng chân với tạ đơn): 3 hiệp x 8-12 lần mỗi chân - Phát triển cơ đùi trước, đùi sau, mông và cải thiện sự cân bằng.','Phụ: Sinh tố whey protein, trái cây sấy khô.'),
		exercise('','Dips (Chống đẩy trên xà kép): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực dưới, cơ tam đầu, cơ vai trước.','Tối: Mì ý sốt thịt bằm, salad cà chua dưa chuột.'),
		exercise('','Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng, đặc biệt là cơ bụng trên.',''),
		exercise('','Kết thúc buổi tập bằng giãn cơ tĩnh (5-10 phút).','')
	].

%Program4: Nam, Tăng cân, người mới, toàn thân, tại nhà, 6 ngày
generate_fitness_program(Fullname, Age, he, Height, Weight, tangcan, Level, fullbody, home, sau, Program) :-
    Program = [
		exercise('Thứ 2', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì sandwich trứng ốp la với phô mai và rau xà lách, sinh tố chuối bơ.'),
		exercise('', 'Burpees: 3 hiệp x 8-12 lần - Bài tập toàn thân, đốt cháy calo, tăng sức bền và sức mạnh.', 'Trưa: Cơm gạo lứt, thịt bò xào rau củ, canh rau.'),
		exercise('', 'Squat (Gánh tạ không tạ): 3 hiệp x 15-20 lần - Phát triển cơ đùi trước, đùi sau, mông.', 'Chiều: Sữa chua Hy Lạp, trái cây, các loại hạt.'),
		exercise('', 'Push-ups (Chống đẩy): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực, vai, tay sau.', 'Tối: Gà nướng mật ong, khoai lang luộc, salad rau trộn.'),
		exercise('', 'Inchworm: 3 hiệp x 10-15 lần - Bài tập toàn thân, tăng cường sức mạnh cơ core, giãn cơ lưng, đùi sau.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 30-60 giây - Tăng cường sức mạnh cơ core.', ''),
		
		exercise('Thứ 3', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Yến mạch với sữa tươi, hoa quả và hạt.'),
		exercise('', 'Jump Squats (Squat bật nhảy): 3 hiệp x 10-15 lần - Bài tập plyometric phát triển sức mạnh và sức bật của cơ chân.', 'Trưa: Cơm gạo lứt, cá hồi nướng, rau củ luộc.'),
		exercise('', 'Lunges (Chùng chân): 3 hiệp x 12-15 lần mỗi chân - Phát triển cơ đùi trước, đùi sau, mông.', 'Chiều: Sinh tố whey protein, trái cây sấy khô.'),
		exercise('', 'Glute Bridges (Nâng hông): 3 hiệp x 15-20 lần - Phát triển cơ mông và đùi sau.', 'Tối: Mì ý sốt thịt bằm, salad cà chua dưa chuột.'),
		exercise('', 'Calf Raises (Nhón bắp chuối): 3 hiệp x 20-25 lần - Phát triển cơ bắp chân.', ''),
		exercise('', 'Superman (Tư thế siêu nhân): 3 hiệp x 15-20 lần - Phát triển cơ lưng dưới.', ''),
		
		exercise('Thứ 4', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cám kẹp thịt nguội và rau củ, sữa chua.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng trên.', 'Trưa: Cơm gạo lứt, thịt heo luộc, canh bí đỏ.'),
		exercise('', 'Leg Raises (Nâng chân): 3 hiệp x 15-20 lần - Phát triển cơ bụng dưới.', 'Chiều: Chuối, các loại hạt.'),
		exercise('', 'Bicycle Crunches (Gập bụng kiểu đạp xe): 3 hiệp x 15-20 lần mỗi bên - Phát triển cơ bụng chéo.', 'Tối: Súp gà nấm, bánh mì nướng.'),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 60 giây - Tăng cường sức mạnh cơ core.', ''),
		exercise('', 'Mountain Climbers (Leo núi): 3 hiệp x 30-60 giây - Bài tập cardio, tăng cường sức mạnh cơ core và đốt cháy calo.', ''),
		
		exercise('Thứ 5', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Trứng chiên rau củ, ngũ cốc granola với sữa.'),
		exercise('', 'Incline Push-ups (Chống đẩy trên ghế dốc): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực trên và vai.', 'Trưa: Cơm gạo lứt, cá kho tộ, rau luộc.'),
		exercise('', 'Diamond Push-ups (Chống đẩy kim cương): 3 hiệp, tối đa số lần có thể - Phát triển cơ tam đầu.', 'Chiều: Bánh protein, sữa đậu nành.'),
		exercise('', 'Triceps Dips (Chống đẩy tay sau trên ghế): 3 hiệp x 12-15 lần - Phát triển cơ tay sau.', 'Tối: Thịt bò bít tết, khoai tây nghiền, salad.'),
		exercise('', 'Bicep Curls (Cuốn tạ với chai nước): 3 hiệp x 15-20 lần mỗi tay - Phát triển cơ tay trước.', ''),
		
		exercise('Thứ 6', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Cháo gà, trứng luộc.'),
		exercise('', 'Jumping Jacks (Nhảy dang tay chân): 3 hiệp x 30 giây - Cardio nhẹ nhàng, khởi động cơ thể.', 'Trưa: Cơm gạo lứt, cá thu rim, canh chua.'),
		exercise('', 'High Knees (Chạy nâng cao gối): 3 hiệp x 30 giây - Cardio, tăng nhịp tim.', 'Chiều: Trái cây, sữa chua.'),
		exercise('', 'Butt Kicks (Chạy đá gót chân): 3 hiệp x 30 giây - Cardio, tăng nhịp tim.', 'Tối: Bún thịt nướng, rau sống.'),
		exercise('', 'Walking Lunges (Chùng chân bước đi): 2 hiệp x 10-12 lần mỗi chân - Phát triển cơ đùi trước, đùi sau, mông.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 2 hiệp, giữ tối đa 30-60 giây - Tăng cường sức mạnh cơ core.', ''),
		
		exercise('Thứ 7', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh cuốn, thịt nướng.'),
		exercise('', 'Bodyweight Squats (Gánh tạ không tạ): 3 hiệp x 15-20 lần - Duy trì sức mạnh cơ chân.', 'Trưa: Cơm gạo lứt, sườn xào chua ngọt, canh rau.'),
		exercise('', 'Push-ups (Chống đẩy): 3 hiệp, tối đa số lần có thể - Duy trì sức mạnh cơ ngực, vai, tay sau.', 'Chiều: Trái cây, sữa chua.'),
		exercise('', 'Supermans (Tư thế siêu nhân): 3 hiệp x 15-20 lần - Duy trì sức mạnh cơ lưng.', 'Tối: Cơm tấm, sườn nướng, bì, chả.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Duy trì sức mạnh cơ bụng.', ''),
		
		exercise('Chủ nhật', 'Nghỉ ngơi hoàn toàn.', '')
	].
	
%Program5: Nam, Tăng cân, người mới, toàn thân, tại nhà, 5 ngày
generate_fitness_program(Fullname, Age, he, Height, Weight, tangcan, Level, fullbody, home, nam, Program) :-
    Program = [
        exercise('Thứ 2', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì sandwich trứng ốp la với phô mai và rau xà lách, sinh tố chuối bơ.'),
		exercise('', 'Burpees: 3 hiệp x 8-12 lần - Bài tập toàn thân, đốt cháy calo, tăng sức bền và sức mạnh.', 'Trưa: Cơm gạo lứt, thịt bò xào rau củ, canh rau.'),
		exercise('', 'Squat (Gánh tạ không tạ): 3 hiệp x 15-20 lần - Phát triển cơ đùi trước, đùi sau, mông.', 'Chiều: Sữa chua Hy Lạp, trái cây, các loại hạt.'),
		exercise('', 'Push-ups (Chống đẩy): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực, vai, tay sau.', 'Tối: Gà nướng mật ong, khoai lang luộc, salad rau trộn.'),
		exercise('', 'Inchworm: 3 hiệp x 10-15 lần - Bài tập toàn thân, tăng cường sức mạnh cơ core, giãn cơ lưng, đùi sau.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 30-60 giây - Tăng cường sức mạnh cơ core.', ''),
		
		exercise('Thứ 3', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Yến mạch với sữa tươi, hoa quả và hạt.'),
		exercise('', 'Jump Squats (Squat bật nhảy): 3 hiệp x 10-15 lần - Bài tập plyometric phát triển sức mạnh và sức bật của cơ chân.', 'Trưa: Cơm gạo lứt, cá hồi nướng, rau củ luộc.'),
		exercise('', 'Lunges (Chùng chân): 3 hiệp x 12-15 lần mỗi chân - Phát triển cơ đùi trước, đùi sau, mông.', 'Chiều: Sinh tố whey protein, trái cây sấy khô.'),
		exercise('', 'Glute Bridges (Nâng hông): 3 hiệp x 15-20 lần - Phát triển cơ mông và đùi sau.', 'Tối: Mì ý sốt thịt bằm, salad cà chua dưa chuột.'),
		exercise('', 'Calf Raises (Nhón bắp chuối): 3 hiệp x 20-25 lần - Phát triển cơ bắp chân.', ''),
		exercise('', 'Superman (Tư thế siêu nhân): 3 hiệp x 15-20 lần - Phát triển cơ lưng dưới.', ''),
		
		exercise('Thứ 4', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cám kẹp thịt nguội và rau củ, sữa chua.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng trên.', 'Trưa: Cơm gạo lứt, thịt heo luộc, canh bí đỏ.'),
		exercise('', 'Leg Raises (Nâng chân): 3 hiệp x 15-20 lần - Phát triển cơ bụng dưới.', 'Chiều: Chuối, các loại hạt.'),
		exercise('', 'Bicycle Crunches (Gập bụng kiểu đạp xe): 3 hiệp x 15-20 lần mỗi bên - Phát triển cơ bụng chéo.', 'Tối: Súp gà nấm, bánh mì nướng.'),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 60 giây - Tăng cường sức mạnh cơ core.', ''),
		exercise('', 'Mountain Climbers (Leo núi): 3 hiệp x 30-60 giây - Bài tập cardio, tăng cường sức mạnh cơ core và đốt cháy calo.', ''),
		
		exercise('Thứ 5', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Trứng chiên rau củ, ngũ cốc granola với sữa.'),
		exercise('', 'Incline Push-ups (Chống đẩy trên ghế dốc): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực trên và vai.', 'Trưa: Cơm gạo lứt, cá kho tộ, rau luộc.'),
		exercise('', 'Diamond Push-ups (Chống đẩy kim cương): 3 hiệp, tối đa số lần có thể - Phát triển cơ tam đầu.', 'Chiều: Bánh protein, sữa đậu nành.'),
		exercise('', 'Triceps Dips (Chống đẩy tay sau trên ghế): 3 hiệp x 12-15 lần - Phát triển cơ tay sau.', 'Tối: Thịt bò bít tết, khoai tây nghiền, salad.'),
		exercise('', 'Bicep Curls (Cuốn tạ với chai nước): 3 hiệp x 15-20 lần mỗi tay - Phát triển cơ tay trước.', ''),
		
		exercise('Thứ 6', 'Nghỉ ngơi', ''),
		
		exercise('Thứ 7', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Cháo gà, trứng luộc.'),
		exercise('', 'Jumping Jacks (Nhảy dang tay chân): 3 hiệp x 30 giây - Cardio nhẹ nhàng, khởi động cơ thể.', 'Trưa: Cơm gạo lứt, cá thu rim, canh chua.'),
		exercise('', 'High Knees (Chạy nâng cao gối): 3 hiệp x 30 giây - Cardio, tăng nhịp tim.', 'Chiều: Trái cây, sữa chua.'),
		exercise('', 'Butt Kicks (Chạy đá gót chân): 3 hiệp x 30 giây - Cardio, tăng nhịp tim.', 'Tối: Bún thịt nướng, rau sống.'),
		exercise('', 'Walking Lunges (Chùng chân bước đi): 2 hiệp x 10-12 lần mỗi chân - Phát triển cơ đùi trước, đùi sau, mông.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 2 hiệp, giữ tối đa 30-60 giây - Tăng cường sức mạnh cơ core.', ''),
		
		exercise('Chủ nhật', 'Nghỉ ngơi', '')
    ].
	
%Program6: Nam, Tăng cân, người mới, toàn thân, tại nhà, 4 ngày
generate_fitness_program(Fullname, Age, he, Height, Weight, tangcan, Level, fullbody, home, bon, Program) :-
    Program = [
        exercise('Thứ 2', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì sandwich trứng ốp la với phô mai và rau xà lách, sinh tố chuối bơ.'),
		exercise('', 'Burpees: 3 hiệp x 8-12 lần - Bài tập toàn thân, đốt cháy calo, tăng sức bền và sức mạnh.', 'Trưa: Cơm gạo lứt, thịt bò xào rau củ, canh rau.'),
		exercise('', 'Squat (Gánh tạ không tạ): 3 hiệp x 15-20 lần - Phát triển cơ đùi trước, đùi sau, mông.', 'Chiều: Sữa chua Hy Lạp, trái cây, các loại hạt.'),
		exercise('', 'Push-ups (Chống đẩy): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực, vai, tay sau.', 'Tối: Gà nướng mật ong, khoai lang luộc, salad rau trộn.'),
		exercise('', 'Inchworm: 3 hiệp x 10-15 lần - Bài tập toàn thân, tăng cường sức mạnh cơ core, giãn cơ lưng, đùi sau.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 30-60 giây - Tăng cường sức mạnh cơ core.', ''),
		
		exercise('Thứ 3', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Yến mạch với sữa tươi, hoa quả và hạt.'),
		exercise('', 'Jump Squats (Squat bật nhảy): 3 hiệp x 10-15 lần - Bài tập plyometric phát triển sức mạnh và sức bật của cơ chân.', 'Trưa: Cơm gạo lứt, cá hồi nướng, rau củ luộc.'),
		exercise('', 'Lunges (Chùng chân): 3 hiệp x 12-15 lần mỗi chân - Phát triển cơ đùi trước, đùi sau, mông.', 'Chiều: Sinh tố whey protein, trái cây sấy khô.'),
		exercise('', 'Glute Bridges (Nâng hông): 3 hiệp x 15-20 lần - Phát triển cơ mông và đùi sau.', 'Tối: Mì ý sốt thịt bằm, salad cà chua dưa chuột.'),
		exercise('', 'Calf Raises (Nhón bắp chuối): 3 hiệp x 20-25 lần - Phát triển cơ bắp chân.', ''),
		exercise('', 'Superman (Tư thế siêu nhân): 3 hiệp x 15-20 lần - Phát triển cơ lưng dưới.', ''),
		
		exercise('Thứ 4', 'Nghỉ ngơi', ''),
		
		exercise('Thứ 5', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cám kẹp thịt nguội và rau củ, sữa chua.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng trên.', 'Trưa: Cơm gạo lứt, thịt heo luộc, canh bí đỏ.'),
		exercise('', 'Leg Raises (Nâng chân): 3 hiệp x 15-20 lần - Phát triển cơ bụng dưới.', 'Chiều: Chuối, các loại hạt.'),
		exercise('', 'Bicycle Crunches (Gập bụng kiểu đạp xe): 3 hiệp x 15-20 lần mỗi bên - Phát triển cơ bụng chéo.', 'Tối: Súp gà nấm, bánh mì nướng.'),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 60 giây - Tăng cường sức mạnh cơ core.', ''),
		exercise('', 'Mountain Climbers (Leo núi): 3 hiệp x 30-60 giây - Bài tập cardio, tăng cường sức mạnh cơ core và đốt cháy calo.', ''),
		
		exercise('Thứ 6', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Trứng chiên rau củ, ngũ cốc granola với sữa.'),
		exercise('', 'Incline Push-ups (Chống đẩy trên ghế dốc): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực trên và vai.', 'Trưa: Cơm gạo lứt, cá kho tộ, rau luộc.'),
		exercise('', 'Diamond Push-ups (Chống đẩy kim cương): 3 hiệp, tối đa số lần có thể - Phát triển cơ tam đầu.', 'Chiều: Bánh protein, sữa đậu nành.'),
		exercise('', 'Triceps Dips (Chống đẩy tay sau trên ghế): 3 hiệp x 12-15 lần - Phát triển cơ tay sau.', 'Tối: Thịt bò bít tết, khoai tây nghiền, salad.'),
		exercise('', 'Bicep Curls (Cuốn tạ với chai nước): 3 hiệp x 15-20 lần mỗi tay - Phát triển cơ tay trước.', ''),
		
		exercise('Thứ 7', 'Nghỉ ngơi', ''),
		
		exercise('Chủ nhật', 'Nghỉ ngơi', '')
    ].
%Program7: Nam, Tăng cân, người mới, chia nhóm, tại nhà, 4 ngày
generate_fitness_program(Fullname, Age, he, Height, Weight, tangcan, Level, split, home, bon, Program) :-
    Program = [
		exercise('Thứ 2: Chân', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì sandwich trứng ốp la với phô mai và rau xà lách, sinh tố chuối bơ.'),
		exercise('', 'Squat (Gánh tạ không tạ): 3 hiệp x 15-20 lần - Phát triển cơ đùi trước, đùi sau, mông.', 'Trưa: Cơm gạo lứt, thịt bò xào rau củ, canh rau.'),
		exercise('', 'Lunges (Chùng chân): 3 hiệp x 12-15 lần mỗi chân - Phát triển cơ đùi trước, đùi sau, mông.', 'Chiều: Sữa chua Hy Lạp, trái cây, các loại hạt.'),
		exercise('', 'Glute Bridges (Nâng hông): 3 hiệp x 15-20 lần - Phát triển cơ mông và đùi sau.', 'Tối: Gà nướng mật ong, khoai lang luộc, salad rau trộn.'),
		exercise('', 'Calf Raises (Nhón bắp chuối): 3 hiệp x 20-25 lần - Phát triển cơ bắp chân.', ''),
		
		exercise('Thứ 3: Ngực - Vai', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Yến mạch với sữa tươi, hoa quả và hạt.'),
		exercise('', 'Push-ups (Chống đẩy): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực, vai, tay sau.', 'Trưa: Cơm gạo lứt, cá hồi nướng, rau củ luộc.'),
		exercise('', 'Incline Push-ups (Chống đẩy trên ghế dốc): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực trên và vai.', 'Chiều: Sinh tố whey protein, trái cây sấy khô.'),
		exercise('', 'Pike Push-ups (Chống đẩy hình chữ V): 3 hiệp, tối đa số lần có thể - Phát triển cơ vai.', 'Tối: Mì ý sốt thịt bằm, salad cà chua dưa chuột.'),
		exercise('', 'Handstand Push-ups (Chống đẩy trồng chuối - nếu có thể): 3 hiệp, tối đa số lần có thể - Phát triển cơ vai.', ''),
		
		exercise('Thứ 4', 'Nghỉ ngơi', ''),
		
		exercise('Thứ 5: Lưng - Tay sau', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cám kẹp thịt nguội và rau củ, sữa chua.'),
		exercise('', 'Pull-ups (Kéo xà đơn - nếu có thể): 3 hiệp, tối đa số lần có thể - Phát triển cơ lưng xô, cơ bắp tay trước.', 'Trưa: Cơm gạo lứt, thịt heo luộc, canh bí đỏ.'),
		exercise('', 'Superman (Tư thế siêu nhân): 3 hiệp x 15-20 lần - Phát triển cơ lưng dưới.', 'Chiều: Chuối, các loại hạt.'),
		exercise('', 'Reverse Snow Angels (Thiên thần ngược): 3 hiệp x 12-15 lần - Phát triển cơ lưng giữa.', 'Tối: Súp gà nấm, bánh mì nướng.'),
		exercise('', 'Triceps Dips (Chống đẩy tay sau trên ghế): 3 hiệp x 12-15 lần - Phát triển cơ tay sau.', ''),
		
		exercise('Thứ 6: Tay trước - Bụng', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Trứng chiên rau củ, ngũ cốc granola với sữa.'),
		exercise('', 'Bicep Curls (Cuốn tạ với chai nước): 3 hiệp x 15-20 lần mỗi tay - Phát triển cơ tay trước.', 'Trưa: Cơm gạo lứt, cá kho tộ, rau luộc.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng trên.', 'Chiều: Bánh protein, sữa đậu nành.'),
		exercise('', 'Leg Raises (Nâng chân): 3 hiệp x 15-20 lần - Phát triển cơ bụng dưới.', 'Tối: Thịt bò bít tết, khoai tây nghiền, salad.'),
		exercise('', 'Bicycle Crunches (Gập bụng kiểu đạp xe): 3 hiệp x 15-20 lần mỗi bên - Phát triển cơ bụng chéo.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 60 giây - Tăng cường sức mạnh cơ core.', ''),
		
		exercise('Thứ 7', 'Nghỉ ngơi', ''),
		
		exercise('Chủ nhật', 'Nghỉ ngơi', '')
	].

%Program7: Nam, Tăng cân, người mới, chia nhóm, tại nhà, 5 ngày
generate_fitness_program(Fullname, Age, he, Height, Weight, tangcan, Level, split, home, nam, Program) :-
    Program = [
		exercise('Thứ 2: Chân - Vai', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì sandwich trứng ốp la với phô mai và rau xà lách, sinh tố chuối bơ.'),
		exercise('', 'Squat: 3 hiệp x 10-15 lần - Phát triển cơ đùi trước, đùi sau, mông.', 'Trưa: Cơm gạo lứt, thịt bò xào rau củ, canh rau.'),
		exercise('', 'Lunge: 3 hiệp x 10-12 lần mỗi chân - Phát triển cơ đùi trước, mông, đùi sau.', 'Chiều: Sữa chua Hy Lạp, trái cây, các loại hạt.'),
		exercise('', 'Nâng bắp chuối: 3 hiệp x 15-20 lần - Phát triển cơ bắp chân.', 'Tối: Gà nướng mật ong, khoai lang luộc, salad rau trộn.'),
		exercise('', 'Nhún vai: 3 hiệp x 10-15 lần - Phát triển cơ vai.', ''),
		
		exercise('Thứ 3: Ngực - Tay sau', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Yến mạch với sữa tươi, hoa quả và hạt.'),
		exercise('', 'Hít đất: 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực, vai trước và cơ tam đầu.', 'Trưa: Cơm gạo lứt, cá hồi nướng, rau củ luộc.'),
		exercise('', 'Chống đẩy trên ghế: 3 hiệp x 8-12 lần - Phát triển cơ ngực dưới, tay sau.', 'Chiều: Sinh tố whey protein, trái cây sấy khô.'),
		exercise('', 'Hít đất ngược: 3 hiệp x 8-12 lần - Phát triển cơ lưng xô, tay sau.', 'Tối: Mì ý sốt thịt bằm, salad cà chua dưa chuột.'),
		
		exercise('Thứ 4: Lưng - Tay trước', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cám kẹp thịt nguội và rau củ, sữa chua.'),
		exercise('', 'Kéo xà đơn: 3 hiệp, tối đa số lần có thể - Phát triển cơ lưng xô, cơ bắp tay trước.', 'Trưa: Cơm gạo lứt, thịt heo luộc, canh bí đỏ.'),
		exercise('', 'Gập bụng: 3 hiệp x 15-20 lần - Phát triển cơ bụng.', 'Chiều: Chuối, các loại hạt.'),
		
		exercise('Thứ 5: Lưng - Tay sau', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cám kẹp thịt nguội và rau củ, sữa chua.'),
		exercise('', 'Pull-ups (Kéo xà đơn - nếu có thể): 3 hiệp, tối đa số lần có thể - Phát triển cơ lưng xô, cơ bắp tay trước.', 'Trưa: Cơm gạo lứt, thịt heo luộc, canh bí đỏ.'),
		exercise('', 'Superman (Tư thế siêu nhân): 3 hiệp x 15-20 lần - Phát triển cơ lưng dưới.', 'Chiều: Chuối, các loại hạt.'),
		exercise('', 'Reverse Snow Angels (Thiên thần ngược): 3 hiệp x 12-15 lần - Phát triển cơ lưng giữa.', 'Tối: Súp gà nấm, bánh mì nướng.'),
		exercise('', 'Triceps Dips (Chống đẩy tay sau trên ghế): 3 hiệp x 12-15 lần - Phát triển cơ tay sau.', ''),
		
		exercise('Thứ 6: Toàn thân', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Trứng chiên rau củ, ngũ cốc granola với sữa.'),
		exercise('', 'Burpees: 3 hiệp x 10-15 lần - Bài tập toàn thân, tăng sức mạnh và sức bền.', 'Trưa: Cơm gạo lứt, cá kho tộ, rau luộc.'),
		exercise('', 'Jumping Jack: 3 hiệp x 20-30 lần - Khởi động làm nóng cơ thể.', 'Chiều: Bánh protein, sữa đậu nành.'),
		exercise('', 'Plank: 3 hiệp, giữ tối đa thời gian có thể - Tăng cường sức mạnh cơ core.', 'Tối: Thịt bò bít tết, khoai tây nghiền, salad.'),
		
		exercise('Thứ 7', 'Nghỉ ngơi', ''),
		
		exercise('Chủ nhật', 'Nghỉ ngơi', '')
	].
%Program8: Nam, Tăng cân, người mới, chia nhóm, tại nhà, 6 ngày
generate_fitness_program(Fullname, Age, he, Height, Weight, tangcan, Level, split, home, sau, Program) :-
    Program = [
		exercise('Thứ 2: Chân - Vai', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì sandwich trứng ốp la với phô mai và rau xà lách, sinh tố chuối bơ.'),
		exercise('', 'Squats (Gánh đùi): 3 hiệp x 10-15 lần - Phát triển cơ đùi trước, đùi sau, mông.', 'Trưa: Cơm gạo lứt, thịt bò xào rau củ, canh rau.'),
		exercise('', 'Lunges (Chùng chân): 3 hiệp x 10-12 lần mỗi chân - Phát triển cơ đùi trước, mông, đùi sau.', 'Chiều: Sữa chua Hy Lạp, trái cây, các loại hạt.'),
		exercise('', 'Calf Raises (Nâng bắp chuối): 3 hiệp x 15-20 lần - Phát triển cơ bắp chân.', 'Tối: Gà nướng mật ong, khoai lang luộc, salad rau trộn.'),
		exercise('', 'Shoulder Shrugs (Nhún vai): 3 hiệp x 10-15 lần - Phát triển cơ vai.', ''),

		exercise('Thứ 3: Ngực - Tay sau', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Yến mạch với sữa tươi, hoa quả và hạt.'),
		exercise('', 'Push-ups (Hít đất): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực, vai trước và cơ tam đầu.', 'Trưa: Cơm gạo lứt, cá hồi nướng, rau củ luộc.'),
		exercise('', 'Incline Push-ups (Chống đẩy trên ghế dốc): 3 hiệp x 8-12 lần - Phát triển cơ ngực dưới, tay sau.', 'Chiều: Sinh tố whey protein, trái cây sấy khô.'),
		exercise('', 'Superman (Siêu nhân): 3 hiệp x 10-15 lần - Phát triển cơ lưng xô, tay sau.', 'Tối: Mì ý sốt thịt bằm, salad cà chua dưa chuột.'),
		
		exercise('Thứ 4: Lưng - Tay trước', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cám kẹp thịt nguội và rau củ, sữa chua.'),
		exercise('', 'Pull-ups (Kéo xà đơn): 3 hiệp, tối đa số lần có thể - Phát triển cơ lưng xô, cơ bắp tay trước.', 'Trưa: Cơm gạo lứt, thịt heo luộc, canh bí đỏ.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng.', 'Chiều: Chuối, các loại hạt.'),
		exercise('', 'Bicep Curls (Cuốn tạ tay trước): 3 hiệp x 10-15 lần - Phát triển cơ tay trước.', 'Tối: Súp gà nấm, bánh mì nướng.'),

		exercise('Thứ 5: Chân - Bụng', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Trứng chiên rau củ, ngũ cốc granola với sữa.'),
		exercise('', 'Bulgarian Split Squat (Chùng chân 1 bên): 3 hiệp x 10-12 lần - Phát triển cơ đùi trước, mông.', 'Trưa: Cơm gạo lứt, cá kho tộ, rau luộc.'),
		exercise('', 'Calf Raises (Nâng bắp chuối): 3 hiệp x 15-20 lần - Phát triển cơ bắp chân.', 'Chiều: Bánh protein, sữa đậu nành.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng trên.', 'Tối: Thịt bò bít tết, khoai tây nghiền, salad.'),
		
		exercise('Thứ 6: Toàn thân - Cường độ thấp', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Cháo gà, trứng luộc.'),
		exercise('', 'Jumping Jacks (Bật nhảy tại chỗ): 2 hiệp x 20 lần.', 'Trưa: Cơm gạo lứt, cá thu rim, canh chua.'),
		exercise('', 'Burpees (Bài tập tổng hợp): 2 hiệp x 8-10 lần.', 'Chiều: Trái cây, sữa chua.'),
		exercise('', 'Mountain Climbers (Leo núi): 2 hiệp x 30 giây.', 'Tối: Bún thịt nướng, rau sống.'),

		exercise('Thứ 7', 'Nghỉ ngơi', ''),
		exercise('Chủ nhật: Toàn thân - Cường độ thấp', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Cháo gà, trứng luộc.'),
		exercise('', 'Jumping Jacks (Bật nhảy tại chỗ): 2 hiệp x 20 lần.', 'Trưa: Cơm gạo lứt, cá thu rim, canh chua.'),
		exercise('', 'Burpees (Bài tập tổng hợp): 2 hiệp x 8-10 lần.', 'Chiều: Trái cây, sữa chua.'),
		exercise('', 'Mountain Climbers (Leo núi): 2 hiệp x 30 giây.', 'Tối: Bún thịt nướng, rau sống.')
	].
%Program9: Nam, Tăng cân, người mới, chia nhóm, Phòng gym, 6 ngày
generate_fitness_program(Fullname, Age, he, Height, Weight, tangcan, Level, split, gym, sau, Program) :-
    Program = [
		% Thứ 2: Chân - Vai
		exercise('Thứ 2: Chân - Vai', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì sandwich trứng ốp la với phô mai và rau xà lách, sinh tố chuối bơ.'),
		exercise('', 'Barbell Back Squats (Gánh tạ đòn sau): 3 hiệp x 8-12 lần - Phát triển cơ đùi trước, đùi sau, mông.', 'Trưa: Cơm gạo lứt, thịt bò xào rau củ, canh rau.'),
		exercise('', 'Leg Press (Đạp tạ chân): 3 hiệp x 10-15 lần - Phát triển cơ đùi trước và mông.', 'Chiều: Sữa chua Hy Lạp, trái cây, các loại hạt.'),
		exercise('', 'Hamstring Curls (Cuốn tạ đùi sau): 3 hiệp x 12-15 lần - Phát triển cơ đùi sau.', 'Tối: Gà nướng mật ong, khoai lang luộc, salad rau trộn.'),
		exercise('', 'Standing Calf Raises (Nhón bắp chuối đứng): 3 hiệp x 15-20 lần - Phát triển cơ bắp chân.', ''),
		exercise('', 'Overhead Press (Đẩy tạ qua đầu): 3 hiệp x 8-12 lần - Phát triển cơ vai.', ''),
		exercise('', 'Lateral Raises (Nâng tạ sang ngang): 3 hiệp x 12-15 lần - Phát triển cơ vai giữa.', ''),

		% Thứ 3: Ngực - Tay sau
		exercise('Thứ 3: Ngực - Tay sau', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Yến mạch với sữa tươi, hoa quả và hạt.'),
		exercise('', 'Barbell Bench Press (Nằm đẩy tạ đòn): 3 hiệp x 8-12 lần - Phát triển cơ ngực, vai trước và cơ tam đầu.', 'Trưa: Cơm gạo lứt, cá hồi nướng, rau củ luộc.'),
		exercise('', 'Incline Dumbbell Press (Nằm đẩy tạ đơn trên ghế dốc): 3 hiệp x 10-15 lần - Phát triển cơ ngực trên.', 'Chiều: Sinh tố whey protein, trái cây sấy khô.'),
		exercise('', 'Dumbbell Flyes (Đẩy tạ đơn dạng bay): 3 hiệp x 12-15 lần - Phát triển cơ ngực.', 'Tối: Mì ý sốt thịt bằm, salad cà chua dưa chuột.'),
		exercise('', 'Cable Crossovers (Kéo cáp ngực): 3 hiệp x 12-15 lần - Phát triển cơ ngực.', ''),
		exercise('', 'Triceps Pushdowns (Đẩy tạ dây cáp xuống): 3 hiệp x 12-15 lần - Phát triển cơ tay sau.', ''),
		exercise('', 'Overhead Dumbbell Extensions (Duỗi tạ đơn qua đầu): 3 hiệp x 12-15 lần - Phát triển cơ tay sau.', ''),

		% Thứ 4: Lưng - Tay trước
		exercise('Thứ 4: Lưng - Tay trước', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cám kẹp thịt nguội và rau củ, sữa chua.'),
		exercise('', 'Pull-ups (Kéo xà đơn): 3 hiệp, tối đa số lần có thể - Phát triển cơ lưng xô, cơ bắp tay trước.', 'Trưa: Cơm gạo lứt, thịt heo luộc, canh bí đỏ.'),
		exercise('', 'Barbell Row (Chèo tạ đòn): 3 hiệp x 8-12 lần - Phát triển cơ lưng xô.', 'Chiều: Chuối, các loại hạt.'),
		exercise('', 'Seated Cable Rows (Chèo cáp ngồi): 3 hiệp x 12-15 lần - Phát triển cơ lưng giữa.', 'Tối: Súp gà nấm, bánh mì nướng.'),
		exercise('', 'Dumbbell Bicep Curls (Cuốn tạ đơn): 3 hiệp x 10-15 lần - Phát triển cơ tay trước.', ''),
		exercise('', 'Hammer Curls (Cuốn tạ đơn kiểu búa): 3 hiệp x 10-15 lần - Phát triển cơ tay trước và cơ cẳng tay.', ''),

		% Thứ 5: Chân - Bụng
		exercise('Thứ 5: Chân - Bụng', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Trứng chiên rau củ, ngũ cốc granola với sữa.'),
		exercise('', 'Romanian Deadlifts (Nâng tạ kiểu Romanian): 3 hiệp x 10-15 lần - Phát triển cơ đùi sau, mông.', 'Trưa: Cơm gạo lứt, cá kho tộ, rau luộc.'),
		exercise('', 'Leg Extensions (Duỗi chân): 3 hiệp x 12-15 lần - Phát triển cơ đùi trước.', 'Chiều: Bánh protein, sữa đậu nành.'),
		exercise('', 'Calf Raises on the Leg Press Machine (Nhón bắp chuối trên máy đạp chân): 3 hiệp x 15-20 lần - Phát triển cơ bắp chân.', 'Tối: Thịt bò bít tết, khoai tây nghiền, salad.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng trên.', ''),
		exercise('', 'Leg Raises (Nâng chân): 3 hiệp x 15-20 lần - Phát triển cơ bụng dưới.', ''),
		exercise('', 'Russian Twists (Xoay người với tạ): 3 hiệp x 15-20 lần mỗi bên - Phát triển cơ bụng chéo.', ''),

		% Thứ 6: Vai - Bắp tay sau
		exercise('Thứ 6: Vai - Bắp tay sau', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Cháo gà, trứng luộc.'),
		exercise('', 'Front Raises (Nâng tạ trước mặt): 3 hiệp x 12-15 lần - Phát triển cơ vai trước.', 'Trưa: Cơm gạo lứt, cá thu rim, canh chua.'),
		exercise('', 'Rear Delt Flyes (Bài tập vai sau): 3 hiệp x 12-15 lần - Phát triển cơ vai sau.', 'Chiều: Trái cây, sữa chua.'),
		exercise('', 'Close-Grip Bench Press (Đẩy tạ đòn hẹp): 3 hiệp x 8-12 lần - Phát triển cơ tam đầu.', 'Tối: Bún thịt nướng, rau sống.'),
		exercise('', 'Triceps Dips (Chống đẩy tay sau): 3 hiệp, tối đa số lần có thể - Phát triển cơ tam đầu.', ''),

		% Thứ 7: Nghỉ ngơi
		exercise('Thứ 7', 'Nghỉ ngơi', ''),

		% Chủ nhật: Toàn thân - Cường độ thấp
		exercise('Chủ nhật: Toàn thân - Cường độ thấp', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Phở bò, 1 quả trứng.'),
		exercise('', 'Treadmill (Chạy bộ trên máy): 15 phút - Duy trì sức bền.', 'Trưa: Cơm gạo lứt, sườn xào chua ngọt, canh cải.'),
		exercise('', 'Dumbbell Lunges (Chùng chân với tạ đơn): 2 hiệp x 10-12 lần mỗi chân - Duy trì sức mạnh cơ chân.', 'Chiều: Sinh tố hoa quả.'),
		exercise('', 'Dumbbell Bench Press (Nằm đẩy tạ đơn): 2 hiệp x 10-12 lần - Duy trì sức mạnh cơ ngực.', 'Tối: Cơm rang thập cẩm.'),
		exercise('', 'Dumbbell Row (Chèo tạ đơn): 2 hiệp x 10-12 lần - Duy trì sức mạnh cơ lưng.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 2 hiệp, giữ tối đa 30-60 giây - Duy trì sức mạnh cơ core.', '')
	].
%Program10: Nam, Tăng cân, người mới, chia nhóm, Phòng gym, 5 ngày
generate_fitness_program(Fullname, Age, he, Height, Weight, tangcan, Level, split, gym, nam, Program) :-
    Program = [
		% Thứ 2: Chân - Vai
		exercise('Thứ 2: Chân - Vai', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì sandwich trứng ốp la với phô mai và rau xà lách, sinh tố chuối bơ.'),
		exercise('', 'Barbell Back Squats (Gánh tạ đòn sau): 3 hiệp x 8-12 lần - Phát triển cơ đùi trước, đùi sau, mông.', 'Trưa: Cơm gạo lứt, thịt bò xào rau củ, canh rau.'),
		exercise('', 'Leg Press (Đạp tạ chân): 3 hiệp x 10-15 lần - Phát triển cơ đùi trước và mông.', 'Chiều: Sữa chua Hy Lạp, trái cây, các loại hạt.'),
		exercise('', 'Hamstring Curls (Cuốn tạ đùi sau): 3 hiệp x 12-15 lần - Phát triển cơ đùi sau.', 'Tối: Gà nướng mật ong, khoai lang luộc, salad rau trộn.'),
		exercise('', 'Standing Calf Raises (Nhón bắp chuối đứng): 3 hiệp x 15-20 lần - Phát triển cơ bắp chân.', ''),
		exercise('', 'Overhead Press (Đẩy tạ qua đầu): 3 hiệp x 8-12 lần - Phát triển cơ vai.', ''),
		exercise('', 'Lateral Raises (Nâng tạ sang ngang): 3 hiệp x 12-15 lần - Phát triển cơ vai giữa.', ''),

		% Thứ 3: Ngực - Tay sau
		exercise('Thứ 3: Ngực - Tay sau', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Yến mạch với sữa tươi, hoa quả và hạt.'),
		exercise('', 'Barbell Bench Press (Nằm đẩy tạ đòn): 3 hiệp x 8-12 lần - Phát triển cơ ngực, vai trước và cơ tam đầu.', 'Trưa: Cơm gạo lứt, cá hồi nướng, rau củ luộc.'),
		exercise('', 'Incline Dumbbell Press (Nằm đẩy tạ đơn trên ghế dốc): 3 hiệp x 10-15 lần - Phát triển cơ ngực trên.', 'Chiều: Sinh tố whey protein, trái cây sấy khô.'),
		exercise('', 'Dumbbell Flyes (Đẩy tạ đơn dạng bay): 3 hiệp x 12-15 lần - Phát triển cơ ngực.', 'Tối: Mì ý sốt thịt bằm, salad cà chua dưa chuột.'),
		exercise('', 'Cable Crossovers (Kéo cáp ngực): 3 hiệp x 12-15 lần - Phát triển cơ ngực.', ''),
		exercise('', 'Triceps Pushdowns (Đẩy tạ dây cáp xuống): 3 hiệp x 12-15 lần - Phát triển cơ tay sau.', ''),
		exercise('', 'Overhead Dumbbell Extensions (Duỗi tạ đơn qua đầu): 3 hiệp x 12-15 lần - Phát triển cơ tay sau.', ''),

		% Thứ 4: Lưng - Tay trước
		exercise('Thứ 4: Lưng - Tay trước', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cám kẹp thịt nguội và rau củ, sữa chua.'),
		exercise('', 'Pull-ups (Kéo xà đơn): 3 hiệp, tối đa số lần có thể - Phát triển cơ lưng xô, cơ bắp tay trước.', 'Trưa: Cơm gạo lứt, thịt heo luộc, canh bí đỏ.'),
		exercise('', 'Barbell Row (Chèo tạ đòn): 3 hiệp x 8-12 lần - Phát triển cơ lưng xô.', 'Chiều: Chuối, các loại hạt.'),
		exercise('', 'Seated Cable Rows (Chèo cáp ngồi): 3 hiệp x 12-15 lần - Phát triển cơ lưng giữa.', 'Tối: Súp gà nấm, bánh mì nướng.'),
		exercise('', 'Dumbbell Bicep Curls (Cuốn tạ đơn): 3 hiệp x 10-15 lần - Phát triển cơ tay trước.', ''),
		exercise('', 'Hammer Curls (Cuốn tạ đơn kiểu búa): 3 hiệp x 10-15 lần - Phát triển cơ tay trước và cơ cẳng tay.', ''),

		% Thứ 5: Chân - Bụng
		exercise('Thứ 5: Chân - Bụng', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Trứng chiên rau củ, ngũ cốc granola với sữa.'),
		exercise('', 'Romanian Deadlifts (Nâng tạ kiểu Romanian): 3 hiệp x 10-15 lần - Phát triển cơ đùi sau, mông.', 'Trưa: Cơm gạo lứt, cá kho tộ, rau luộc.'),
		exercise('', 'Leg Extensions (Duỗi chân): 3 hiệp x 12-15 lần - Phát triển cơ đùi trước.', 'Chiều: Bánh protein, sữa đậu nành.'),
		exercise('', 'Calf Raises on the Leg Press Machine (Nhón bắp chuối trên máy đạp chân): 3 hiệp x 15-20 lần - Phát triển cơ bắp chân.', 'Tối: Thịt bò bít tết, khoai tây nghiền, salad.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng trên.', ''),
		exercise('', 'Leg Raises (Nâng chân): 3 hiệp x 15-20 lần - Phát triển cơ bụng dưới.', ''),
		exercise('', 'Russian Twists (Xoay người với tạ): 3 hiệp x 15-20 lần mỗi bên - Phát triển cơ bụng chéo.', ''),

		% Thứ 6: Vai - Bắp tay sau
		exercise('Thứ 6: Vai - Bắp tay sau', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Cháo gà, trứng luộc.'),
		exercise('', 'Front Raises (Nâng tạ trước mặt): 3 hiệp x 12-15 lần - Phát triển cơ vai trước.', 'Trưa: Cơm gạo lứt, cá thu rim, canh chua.'),
		exercise('', 'Rear Delt Flyes (Bài tập vai sau): 3 hiệp x 12-15 lần - Phát triển cơ vai sau.', 'Chiều: Trái cây, sữa chua.'),
		exercise('', 'Close-Grip Bench Press (Đẩy tạ đòn hẹp): 3 hiệp x 8-12 lần - Phát triển cơ tam đầu.', 'Tối: Bún thịt nướng, rau sống.'),
		exercise('', 'Triceps Dips (Chống đẩy tay sau): 3 hiệp, tối đa số lần có thể - Phát triển cơ tam đầu.', ''),

		% Thứ 7: Nghỉ ngơi
		exercise('Thứ 7', 'Nghỉ ngơi', ''),

		% Chủ nhật: Nghỉ ngơi
		exercise('Chủ nhật', 'Nghỉ ngơi', '')
	].
	
%Program12: Nam, Tăng cân, người mới, chia nhóm, Phòng gym, 4 ngày
generate_fitness_program(Fullname, Age, he, Height, Weight, tangcan, Level, split, gym, bon, Program) :-
    Program = [
		exercise('Thứ 2: Chân - Vai', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì sandwich trứng ốp la với phô mai và rau xà lách, sinh tố chuối bơ.'),
		exercise('', 'Barbell Back Squats (Gánh tạ đòn sau): 3 hiệp x 8-12 lần - Phát triển cơ đùi trước, đùi sau, mông.', 'Trưa: Cơm gạo lứt, thịt bò xào rau củ, canh rau.'),
		exercise('', 'Leg Press (Đạp tạ chân): 3 hiệp x 10-15 lần - Phát triển cơ đùi trước và mông.', 'Chiều: Sữa chua Hy Lạp, trái cây, các loại hạt.'),
		exercise('', 'Hamstring Curls (Cuốn tạ đùi sau): 3 hiệp x 12-15 lần - Phát triển cơ đùi sau.', 'Tối: Gà nướng mật ong, khoai lang luộc, salad rau trộn.'),
		exercise('', 'Standing Calf Raises (Nhón bắp chuối đứng): 3 hiệp x 15-20 lần - Phát triển cơ bắp chân.', ''),
		exercise('', 'Overhead Press (Đẩy tạ qua đầu): 3 hiệp x 8-12 lần - Phát triển cơ vai.', ''),
		exercise('', 'Lateral Raises (Nâng tạ sang ngang): 3 hiệp x 12-15 lần - Phát triển cơ vai giữa.', ''),

		exercise('Thứ 3: Ngực - Tay sau', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Yến mạch với sữa tươi, hoa quả và hạt.'),
		exercise('', 'Barbell Bench Press (Nằm đẩy tạ đòn): 3 hiệp x 8-12 lần - Phát triển cơ ngực, vai trước và cơ tam đầu.', 'Trưa: Cơm gạo lứt, cá hồi nướng, rau củ luộc.'),
		exercise('', 'Incline Dumbbell Press (Nằm đẩy tạ đơn trên ghế dốc): 3 hiệp x 10-15 lần - Phát triển cơ ngực trên.', 'Chiều: Sinh tố whey protein, trái cây sấy khô.'),
		exercise('', 'Dumbbell Flyes (Đẩy tạ đơn dạng bay): 3 hiệp x 12-15 lần - Phát triển cơ ngực.', 'Tối: Mì ý sốt thịt bằm, salad cà chua dưa chuột.'),
		exercise('', 'Cable Crossovers (Kéo cáp ngực): 3 hiệp x 12-15 lần - Phát triển cơ ngực.', ''),
		exercise('', 'Triceps Pushdowns (Đẩy tạ dây cáp xuống): 3 hiệp x 12-15 lần - Phát triển cơ tay sau.', ''),
		exercise('', 'Overhead Dumbbell Extensions (Duỗi tạ đơn qua đầu): 3 hiệp x 12-15 lần - Phát triển cơ tay sau.', ''),

		exercise('Thứ 4', 'Nghỉ ngơi', ''),

		exercise('Thứ 5: Lưng - Tay trước', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cám kẹp thịt nguội và rau củ, sữa chua.'),
		exercise('', 'Pull-ups (Kéo xà đơn): 3 hiệp, tối đa số lần có thể - Phát triển cơ lưng xô, cơ bắp tay trước. (Nếu chưa kéo được xà, bạn có thể tập Lat Pulldowns (kéo xà lat) thay thế).', 'Trưa: Cơm gạo lứt, thịt heo luộc, canh bí đỏ.'),
		exercise('', 'Barbell Row (Chèo tạ đòn): 3 hiệp x 8-12 lần - Phát triển cơ lưng xô.', 'Chiều: Chuối, các loại hạt.'),
		exercise('', 'Seated Cable Rows (Chèo cáp ngồi): 3 hiệp x 12-15 lần - Phát triển cơ lưng giữa.', 'Tối: Súp gà nấm, bánh mì nướng.'),
		exercise('', 'Dumbbell Bicep Curls (Cuốn tạ đơn): 3 hiệp x 10-15 lần - Phát triển cơ tay trước.', ''),
		exercise('', 'Hammer Curls (Cuốn tạ đơn kiểu búa): 3 hiệp x 10-15 lần - Phát triển cơ tay trước và cơ cẳng tay.', ''),

		exercise('Thứ 6', 'Nghỉ ngơi', ''),

		exercise('Thứ 7: Toàn thân (Cường độ trung bình)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Trứng chiên rau củ, ngũ cốc granola với sữa.'),
		exercise('', 'Deadlifts (Nâng tạ đòn): 2 hiệp x 8-10 lần - Phát triển cơ lưng dưới, đùi sau, mông. (Lưu ý kỹ thuật để tránh chấn thương)', 'Trưa: Cơm gạo lứt, cá kho tộ, rau luộc.'),
		exercise('', 'Overhead Press (Đẩy tạ qua đầu): 2 hiệp x 10-12 lần - Phát triển cơ vai.', 'Chiều: Bánh protein, sữa đậu nành.'),
		exercise('', 'Dumbbell Bench Press (Nằm đẩy tạ đơn): 2 hiệp x 10-12 lần - Phát triển cơ ngực.', 'Tối: Thịt bò bít tết, khoai tây nghiền, salad.'),
		exercise('', 'Lat Pulldowns (Kéo xà lat): 2 hiệp x 12-15 lần - Phát triển cơ lưng.', ''),
		
		exercise('Chủ nhật', 'Nghỉ ngơi', '')
	].

%Program13: Nam, Giảm cân,Phòng gym, 4 ngày
generate_fitness_program(Fullname, Age, he, Height, Weight, giamcan, Level, Type, gym, bon, Program) :-
    Program = [
		exercise('Thứ 2: Chân - Vai (Cường độ cao)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát yến mạch với sữa tươi không đường, hoa quả tươi và 1 ít hạt hạnh nhân.'),
		exercise('', 'Barbell Back Squats (Gánh tạ đòn sau): 3 hiệp x 12-15 lần - Đốt mỡ, phát triển cơ đùi trước, đùi sau, mông.', 'Trưa: 1 đĩa salad ức gà với rau củ quả (dầu giấm/ sốt mè rang), 1 củ khoai lang nhỏ luộc.'),
		exercise('', 'Leg Press (Đạp tạ chân): 3 hiệp x 15-20 lần - Đốt mỡ, phát triển cơ đùi trước và mông.', 'Chiều: 1 quả táo, 1 hũ sữa chua không đường.'),
		exercise('', 'Walking Lunges (Chùng chân di chuyển): 3 hiệp x 10-12 lần mỗi chân - Đốt mỡ, phát triển cơ đùi trước, mông, đùi sau.', 'Tối: Cá hồi nướng, rau củ hấp.'),
		exercise('', 'Standing Calf Raises (Nhón bắp chuối đứng): 3 hiệp x 20-25 lần - Phát triển cơ bắp chân.', ''),
		exercise('', 'Overhead Press (Đẩy tạ qua đầu): 3 hiệp x 12-15 lần - Phát triển cơ vai.', ''),
		exercise('', 'Lateral Raises (Nâng tạ sang ngang): 3 hiệp x 15-20 lần - Phát triển cơ vai giữa.', ''),

		exercise('Thứ 3: Ngực - Tay sau (Cường độ cao)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 2 quả trứng luộc, 1 lát bánh mì đen nguyên cám, 1 quả chuối.'),
		exercise('', 'Incline Dumbbell Press (Nằm đẩy tạ đơn trên ghế dốc): 3 hiệp x 12-15 lần - Phát triển cơ ngực trên.', 'Trưa: Cơm gạo lứt, thịt ức gà luộc, canh rau cải.'),
		exercise('', 'Dumbbell Bench Press (Nằm đẩy tạ đơn): 3 hiệp x 12-15 lần - Phát triển cơ ngực.', 'Chiều: 1 cốc sinh tố whey protein với rau xanh.'),
		exercise('', 'Cable Crossovers (Kéo cáp ngực): 3 hiệp x 15-20 lần - Phát triển cơ ngực.', 'Tối: Thịt bò xào rau củ, 1 chén cơm gạo lứt.'),
		exercise('', 'Triceps Pushdowns (Đẩy tạ dây cáp xuống): 3 hiệp x 15-20 lần - Phát triển cơ tay sau.', ''),
		exercise('', 'Overhead Dumbbell Extensions (Duỗi tạ đơn qua đầu): 3 hiệp x 15-20 lần - Phát triển cơ tay sau.', ''),
		exercise('', 'Superset (Kết hợp 2 bài tập không nghỉ): Dips (Chống đẩy tay sau) 3 hiệp tối đa + Close-Grip Bench Press (Đẩy tạ đòn hẹp) 3 hiệp x 12-15 lần - Phát triển cơ tam đầu.', ''),

		exercise('Thứ 4', 'Nghỉ ngơi', ''),
		
		exercise('Thứ 5: Lưng - Tay trước (Cường độ cao)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cám kẹp trứng và rau củ, sữa chua không đường.'),
		exercise('', 'Pull-ups (Kéo xà đơn): 3 hiệp, tối đa số lần có thể - Phát triển cơ lưng xô, cơ bắp tay trước. (Nếu chưa kéo được xà, bạn có thể tập Lat Pulldowns (kéo xà lat) thay thế).', 'Trưa: Cơm gạo lứt, cá diêu hồng hấp, rau luộc.'),
		exercise('', 'Lat Pulldowns (Kéo xà lat): 3 hiệp x 12-15 lần - Phát triển cơ lưng xô.', 'Chiều: 1 củ khoai lang luộc, 1 nắm hạt điều.'),
		exercise('', 'Seated Cable Rows (Chèo cáp ngồi): 3 hiệp x 15-20 lần - Phát triển cơ lưng giữa.', 'Tối: Súp gà nấm, salad rau trộn.'),
		exercise('', 'Dumbbell Bicep Curls (Cuốn tạ đơn): 3 hiệp x 12-15 lần - Phát triển cơ tay trước.', ''),
		exercise('', 'Hammer Curls (Cuốn tạ đơn kiểu búa): 3 hiệp x 12-15 lần - Phát triển cơ tay trước và cơ cẳng tay.', ''),
		exercise('', 'Barbell Curls (Cuốn tạ đòn): 3 hiệp x 10-12 lần - Phát triển cơ tay trước.', ''),

		exercise('Thứ 6', 'Nghỉ ngơi', ''),
		
		exercise('Thứ 7: Cardio - Bụng (Cường độ trung bình)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát sữa chua không đường với hoa quả tươi và granola.'),
		exercise('', 'Chạy bộ trên máy (tốc độ vừa phải): 30 phút - Đốt mỡ thừa, tăng cường sức bền.', 'Trưa: Cơm gạo lứt, thịt lợn luộc, canh rau mồng tơi.'),
		exercise('', 'HIIT (High Intensity Interval Training) trên máy chạy bộ: Chạy nhanh 30 giây, đi bộ 30 giây, lặp lại 10-15 lần - Đốt mỡ thừa hiệu quả.', 'Chiều: Trái cây, 1 ít các loại hạt.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 20-25 lần - Phát triển cơ bụng trên.', 'Tối: Canh rau củ thập cẩm, đậu phụ hấp.'),
		exercise('', 'Leg Raises (Nâng chân): 3 hiệp x 20-25 lần - Phát triển cơ bụng dưới.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 60 giây - Tăng cường sức mạnh cơ core.', ''),
		exercise('', 'Russian Twists (Xoay người với tạ): 3 hiệp x 20-25 lần mỗi bên - Phát triển cơ bụng chéo.', ''),
		
		
		exercise('Chủ nhật', 'Nghỉ ngơi', '')
		
	].	
%Program13.1: Nam, Giảm cân,Tại nhà, 4 ngày
generate_fitness_program(Fullname, Age, he, Height, Weight, giamcan, Level, Type, home, bon, Program) :-
    Program = [
		exercise('Thứ 2: Toàn thân (Cường độ cao)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát yến mạch với sữa tươi không đường, hoa quả tươi và 1 ít hạt chia.'),
		exercise('', 'Jumping Jacks (Bật nhảy tại chỗ): 3 hiệp x 20 lần - Khởi động, tăng nhịp tim.', 'Trưa: 1 đĩa salad ức gà với rau củ quả (dầu giấm/ sốt mè rang), 1 củ khoai lang nhỏ luộc.'),
		exercise('', 'Burpees (Bài tập tổng hợp): 3 hiệp x 10-15 lần - Đốt mỡ, tăng sức mạnh và sức bền.', 'Chiều: 1 quả táo, 1 hũ sữa chua không đường.'),
		exercise('', 'Push-ups (Hít đất): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực, vai, tay sau.', 'Tối: Cá hồi nướng, rau củ hấp.'),
		exercise('', 'Squats (Gánh đùi): 3 hiệp x 15-20 lần - Đốt mỡ, phát triển cơ đùi trước, đùi sau, mông.', ''),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 20-25 lần - Phát triển cơ bụng trên.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 60 giây - Tăng cường sức mạnh cơ core.', ''),
		
		exercise('Thứ 3: Nghỉ ngơi', '', ''),

		exercise('Thứ 4: Ngực - Tay sau', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 2 quả trứng luộc, 1 lát bánh mì đen nguyên cám, 1 quả chuối.'),
		exercise('', 'Push-ups (Hít đất): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực, vai trước và cơ tam đầu.', 'Trưa: Cơm gạo lứt, thịt ức gà luộc, canh rau cải.'),
		exercise('', 'Incline Push-ups (Chống đẩy trên ghế dốc): 3 hiệp x 12-15 lần - Phát triển cơ ngực trên, vai.', 'Chiều: 1 cốc sinh tố whey protein với rau xanh.'),
		exercise('', 'Dips (Chống đẩy tay sau) (có thể dùng ghế): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực dưới, cơ tam đầu.', 'Tối: Thịt bò xào rau củ, 1 chén cơm gạo lứt.'),
		
		exercise('Thứ 5: Nghỉ ngơi', '', ''),

		exercise('Thứ 6: Chân - Vai', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cám kẹp trứng và rau củ, sữa chua không đường.'),
		exercise('', 'Squats (Gánh đùi): 3 hiệp x 15-20 lần - Phát triển cơ đùi trước, đùi sau, mông.', 'Trưa: Cơm gạo lứt, cá diêu hồng hấp, rau luộc.'),
		exercise('', 'Lunges (Chùng chân): 3 hiệp x 12-15 lần mỗi chân - Phát triển cơ đùi trước, mông, đùi sau.', 'Chiều: 1 củ khoai lang luộc, 1 nắm hạt điều.'),
		exercise('', 'Calf Raises (Nâng bắp chuối): 3 hiệp x 20-25 lần - Phát triển cơ bắp chân.', 'Tối: Súp gà nấm, salad rau trộn.'),
		exercise('', 'Shoulder Shrugs (Nhún vai) (có thể sử dụng tạ): 3 hiệp x 15-20 lần - Phát triển cơ vai.', ''),
		
		exercise('Thứ 7: Nghỉ ngơi', '', ''),

		exercise('Chủ nhật: Lưng - Tay trước - Bụng', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát sữa chua không đường với hoa quả tươi và granola.'),
		exercise('', 'Pull-ups (Kéo xà đơn): 3 hiệp, tối đa số lần có thể - Phát triển cơ lưng xô, cơ bắp tay trước.', 'Trưa: Cơm gạo lứt, thịt lợn luộc, canh rau mồng tơi.'),
		exercise('', 'Superman (Siêu nhân): 3 hiệp x 12-15 lần - Phát triển cơ lưng.', 'Chiều: Trái cây, 1 ít các loại hạt.'),
		exercise('', 'Reverse Snow Angels (Thiên thần ngược): 3 hiệp x 12-15 lần - Phát triển cơ lưng giữa.', 'Tối: Canh rau củ thập cẩm, đậu phụ hấp.'),
		exercise('', 'Bicep Curls (Cuốn tạ) (có thể sử dụng chai nước): 3 hiệp x 15-20 lần - Phát triển cơ tay trước.', ''),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 20-25 lần - Phát triển cơ bụng trên.', ''),
		exercise('', 'Leg Raises (Nâng chân): 3 hiệp x 20-25 lần - Phát triển cơ bụng dưới.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 60 giây - Tăng cường sức mạnh cơ core.', ''),
		exercise('', 'Russian Twists (Xoay người) (có thể dùng chai nước): 3 hiệp x 20-25 lần mỗi bên - Phát triển cơ bụng chéo.', '')
	].

	
%Program14: Nam, Giảm cân, Gym, 5 ngày
generate_fitness_program(Fullname, Age, he, Height, Weight, giamcan, Level, Type, gym, nam, Program) :-
    Program = [
		exercise('Thứ 2: Chân - Vai (Cường độ cao)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát yến mạch với sữa tươi không đường, hoa quả tươi và 1 ít hạt hạnh nhân.'),
		exercise('', 'Barbell Back Squats (Gánh tạ đòn sau): 3 hiệp x 12-15 lần - Đốt mỡ, phát triển cơ đùi trước, đùi sau, mông.', 'Trưa: 1 đĩa salad ức gà với rau củ quả (dầu giấm/ sốt mè rang), 1 củ khoai lang nhỏ luộc.'),
		exercise('', 'Leg Press (Đạp tạ chân): 3 hiệp x 15-20 lần - Đốt mỡ, phát triển cơ đùi trước và mông.', 'Chiều: 1 quả táo, 1 hũ sữa chua không đường.'),
		exercise('', 'Walking Lunges (Chùng chân di chuyển): 3 hiệp x 10-12 lần mỗi chân - Đốt mỡ, phát triển cơ đùi trước, mông, đùi sau.', 'Tối: Cá hồi nướng, rau củ hấp.'),
		exercise('', 'Standing Calf Raises (Nhón bắp chuối đứng): 3 hiệp x 20-25 lần - Phát triển cơ bắp chân.', ''),
		exercise('', 'Overhead Press (Đẩy tạ qua đầu): 3 hiệp x 12-15 lần - Phát triển cơ vai.', ''),
		exercise('', 'Lateral Raises (Nâng tạ sang ngang): 3 hiệp x 15-20 lần - Phát triển cơ vai giữa.', ''),

		exercise('Thứ 3: Ngực - Tay sau (Cường độ cao)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 2 quả trứng luộc, 1 lát bánh mì đen nguyên cám, 1 quả chuối.'),
		exercise('', 'Incline Dumbbell Press (Nằm đẩy tạ đơn trên ghế dốc): 3 hiệp x 12-15 lần - Phát triển cơ ngực trên.', 'Trưa: Cơm gạo lứt, thịt ức gà luộc, canh rau cải.'),
		exercise('', 'Dumbbell Bench Press (Nằm đẩy tạ đơn): 3 hiệp x 12-15 lần - Phát triển cơ ngực.', 'Chiều: 1 cốc sinh tố whey protein với rau xanh.'),
		exercise('', 'Cable Crossovers (Kéo cáp ngực): 3 hiệp x 15-20 lần - Phát triển cơ ngực.', 'Tối: Thịt bò xào rau củ, 1 chén cơm gạo lứt.'),
		exercise('', 'Triceps Pushdowns (Đẩy tạ dây cáp xuống): 3 hiệp x 15-20 lần - Phát triển cơ tay sau.', ''),
		exercise('', 'Overhead Dumbbell Extensions (Duỗi tạ đơn qua đầu): 3 hiệp x 15-20 lần - Phát triển cơ tay sau.', ''),
		exercise('', 'Superset (Kết hợp 2 bài tập không nghỉ): Dips (Chống đẩy tay sau) 3 hiệp tối đa + Close-Grip Bench Press (Đẩy tạ đòn hẹp) 3 hiệp x 12-15 lần - Phát triển cơ tam đầu.', ''),

		exercise('Thứ 4: Nghỉ ngơi', '', ''),

		exercise('Thứ 5: Cardio - Bụng (Cường độ trung bình)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát sữa chua không đường với hoa quả tươi và granola.'),
		exercise('', 'Chạy bộ trên máy (tốc độ vừa phải): 30 phút - Đốt mỡ thừa, tăng cường sức bền.', 'Trưa: Cơm gạo lứt, thịt lợn luộc, canh rau mồng tơi.'),
		exercise('', 'HIIT (High Intensity Interval Training) trên máy chạy bộ: Chạy nhanh 30 giây, đi bộ 30 giây, lặp lại 10-15 lần - Đốt mỡ thừa hiệu quả.', 'Chiều: Trái cây, 1 ít các loại hạt.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 20-25 lần - Phát triển cơ bụng trên.', 'Tối: Canh rau củ thập cẩm, đậu phụ hấp.'),
		exercise('', 'Leg Raises (Nâng chân): 3 hiệp x 20-25 lần - Phát triển cơ bụng dưới.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 60 giây - Tăng cường sức mạnh cơ core.', ''),
		exercise('', 'Russian Twists (Xoay người với tạ): 3 hiệp x 20-25 lần mỗi bên - Phát triển cơ bụng chéo.', ''),

		exercise('Thứ 6: Nghỉ ngơi', '', ''),

		exercise('Thứ 7: Toàn thân (Cường độ trung bình)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Trứng chiên rau củ, ngũ cốc granola với sữa.'),
		exercise('', 'Deadlifts (Nâng tạ đòn): 2 hiệp x 8-10 lần - Phát triển cơ lưng dưới, đùi sau, mông.', 'Trưa: Cơm gạo lứt, cá kho tộ, rau luộc.'),
		exercise('', 'Overhead Press (Đẩy tạ qua đầu): 2 hiệp x 10-12 lần - Phát triển cơ vai.', 'Chiều: Bánh protein, sữa đậu nành.'),
		exercise('', 'Dumbbell Bench Press (Nằm đẩy tạ đơn): 2 hiệp x 10-12 lần - Phát triển cơ ngực.', 'Tối: Thịt bò bít tết, khoai tây nghiền, salad.'),
		exercise('', 'Lat Pulldowns (Kéo xà lat): 2 hiệp x 12-15 lần - Phát triển cơ lưng.', ''),

		exercise('Chủ nhật: Cardio - Bụng (Cường độ thấp)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát cháo yến mạch với hoa quả tươi.'),
		exercise('', 'Đạp xe: 30 phút - Đốt mỡ thừa, thư giãn.', 'Trưa: Cơm gạo lứt, cá hấp, canh rau củ.'),
		exercise('', 'Crunches (Gập bụng): 2 hiệp x 15-20 lần - Duy trì cơ bụng.', 'Chiều: Sinh tố hoa quả ít đường.'),
		exercise('', 'Plank (Chống đẩy tĩnh): 2 hiệp, giữ tối đa 45 giây - Duy trì sức mạnh cơ core.', 'Tối: Salad rau trộn với tôm/ ức gà.')
	].
%Program14.1: Nam, Giảm cân, Tại nhà, 5 ngày
generate_fitness_program(Fullname, Age, he, Height, Weight, giamcan, Level, Type, home, nam, Program) :-
    Program = [
		exercise('Thứ 2: Toàn thân (Cường độ cao)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát yến mạch với sữa tươi không đường, hoa quả tươi và 1 ít hạt chia.'),  
		exercise('', 'Jumping Jacks (Bật nhảy tại chỗ): 3 hiệp x 20 lần - Khởi động, tăng nhịp tim.', 'Trưa: 1 đĩa salad ức gà với rau củ quả (dầu giấm/ sốt mè rang), 1 củ khoai lang nhỏ luộc.'),
		exercise('', 'Burpees (Bài tập tổng hợp): 3 hiệp x 10-15 lần - Đốt mỡ, tăng sức mạnh và sức bền.', 'Chiều: 1 quả táo, 1 hũ sữa chua không đường.'),
		exercise('', 'Push-ups (Hít đất): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực, vai, tay sau.', 'Tối: Cá hồi nướng, rau củ hấp.'),
		exercise('', 'Squats (Gánh đùi): 3 hiệp x 15-20 lần - Đốt mỡ, phát triển cơ đùi trước, đùi sau, mông.', ''),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 20-25 lần - Phát triển cơ bụng trên.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 60 giây - Tăng cường sức mạnh cơ core.', ''),

		exercise('Thứ 3: Ngực - Tay sau', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 2 quả trứng luộc, 1 lát bánh mì đen nguyên cám, 1 quả chuối.'),
		exercise('', 'Push-ups (Hít đất): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực, vai trước và cơ tam đầu.', 'Trưa: Cơm gạo lứt, thịt ức gà luộc, canh rau cải.'),
		exercise('', 'Incline Push-ups (Chống đẩy trên ghế dốc): 3 hiệp x 12-15 lần - Phát triển cơ ngực trên, vai.', 'Chiều: 1 cốc sinh tố whey protein với rau xanh.'),
		exercise('', 'Dips (Chống đẩy tay sau): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực dưới, cơ tam đầu.', 'Tối: Thịt bò xào rau củ, 1 chén cơm gạo lứt.'),

		exercise('Thứ 4: Chân - Vai', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cám kẹp trứng và rau củ, sữa chua không đường.'),
		exercise('', 'Squats (Gánh đùi): 3 hiệp x 15-20 lần - Phát triển cơ đùi trước, đùi sau, mông.', 'Trưa: Cơm gạo lứt, cá diêu hồng hấp, rau luộc.'),
		exercise('', 'Lunges (Chùng chân): 3 hiệp x 12-15 lần mỗi chân - Phát triển cơ đùi trước, mông, đùi sau.', 'Chiều: 1 củ khoai lang luộc, 1 nắm hạt điều.'),
		exercise('', 'Calf Raises (Nâng bắp chuối): 3 hiệp x 20-25 lần - Phát triển cơ bắp chân.', 'Tối: Súp gà nấm, salad rau trộn.'),
		exercise('', 'Shoulder Shrugs (Nhún vai): 3 hiệp x 15-20 lần - Phát triển cơ vai.', ''),

		exercise('Thứ 5: Lưng - Tay trước', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát sữa chua không đường với hoa quả tươi và granola.'),
		exercise('', 'Pull-ups (Kéo xà đơn): 3 hiệp, tối đa số lần có thể - Phát triển cơ lưng xô, cơ bắp tay trước.', 'Trưa: Cơm gạo lứt, thịt lợn luộc, canh rau mồng tơi.'),
		exercise('', 'Superman (Siêu nhân): 3 hiệp x 12-15 lần - Phát triển cơ lưng.', 'Chiều: Trái cây, 1 ít các loại hạt.'),
		exercise('', 'Reverse Snow Angels (Thiên thần ngược): 3 hiệp x 12-15 lần - Phát triển cơ lưng giữa.', 'Tối: Canh rau củ thập cẩm, đậu phụ hấp.'),
		exercise('', 'Bicep Curls (Cuốn tạ): 3 hiệp x 15-20 lần - Phát triển cơ tay trước.', ''),

		exercise('Thứ 6: Cardio - Bụng (Cường độ trung bình)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Trứng chiên rau củ, ngũ cốc granola với sữa.'),
		exercise('', 'Chạy bộ tại chỗ (high knees, butt kicks): 20-30 phút - Đốt mỡ thừa, tăng cường sức bền.', 'Trưa: Cơm gạo lứt, cá kho tộ, rau luộc.'),
		exercise('', 'Mountain Climbers (Leo núi): 3 hiệp x 30 giây - Bài tập cardio, tăng nhịp tim.', 'Chiều: Bánh protein, sữa đậu nành.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 20-25 lần - Phát triển cơ bụng trên.', 'Tối: Thịt bò bít tết, khoai tây nghiền, salad.'),
		exercise('', 'Leg Raises (Nâng chân): 3 hiệp x 20-25 lần - Phát triển cơ bụng dưới.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 60 giây - Tăng cường sức mạnh cơ core.', ''),
		exercise('', 'Russian Twists (Xoay người): 3 hiệp x 20-25 lần mỗi bên - Phát triển cơ bụng chéo.', ''),

		exercise('Thứ 7: Nghỉ ngơi', '', ''),

		exercise('Chủ nhật: Toàn thân (Cường độ thấp)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát cháo yến mạch với hoa quả tươi.'),
		exercise('', 'Jumping Jacks (Bật nhảy tại chỗ): 2 hiệp x 15 lần - Khởi động nhẹ nhàng.', 'Trưa: Cơm gạo lứt, cá hấp, canh rau củ.'),
		exercise('', 'Push-ups (Hít đất): 2 hiệp, tối đa số lần có thể - Duy trì sức mạnh cơ ngực.', 'Chiều: Sinh tố hoa quả ít đường.'),
		exercise('', 'Squats (Gánh đùi): 2 hiệp x 15-20 lần - Duy trì sức mạnh cơ chân.', 'Tối: Salad rau trộn với tôm/ ức gà.'),
		exercise('', 'Plank (Chống đẩy tĩnh): 2 hiệp, giữ tối đa 30 giây - Duy trì sức mạnh cơ core.', '')
	].

	
%Program15: Nam, Giảm cân, Phòng gym, 6 ngày
generate_fitness_program(Fullname, Age, he, Height, Weight, giamcan, Level, Type, gym, sau, Program) :-
    Program = [
		exercise('Thứ 2: Chân - Vai (Cường độ cao)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát yến mạch với sữa tươi không đường, hoa quả tươi và 1 ít hạt hạnh nhân.'),
		exercise('', 'Barbell Back Squats (Gánh tạ đòn sau): 3 hiệp x 12-15 lần - Đốt mỡ, phát triển cơ đùi trước, đùi sau, mông.', 'Trưa: 1 đĩa salad ức gà với rau củ quả (dầu giấm/ sốt mè rang), 1 củ khoai lang nhỏ luộc.'),
		exercise('', 'Leg Press (Đạp tạ chân): 3 hiệp x 15-20 lần - Đốt mỡ, phát triển cơ đùi trước và mông.', 'Chiều: 1 quả táo, 1 hũ sữa chua không đường.'),
		exercise('', 'Walking Lunges (Chùng chân di chuyển): 3 hiệp x 10-12 lần mỗi chân - Đốt mỡ, phát triển cơ đùi trước, mông, đùi sau.', 'Tối: Cá hồi nướng, rau củ hấp.'),
		exercise('', 'Standing Calf Raises (Nhón bắp chuối đứng): 3 hiệp x 20-25 lần - Phát triển cơ bắp chân.', ''),
		exercise('', 'Overhead Press (Đẩy tạ qua đầu): 3 hiệp x 12-15 lần - Phát triển cơ vai.', ''),
		exercise('', 'Lateral Raises (Nâng tạ sang ngang): 3 hiệp x 15-20 lần - Phát triển cơ vai giữa.', ''),

		exercise('Thứ 3: Ngực - Tay sau (Cường độ cao)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 2 quả trứng luộc, 1 lát bánh mì đen nguyên cám, 1 quả chuối.'),
		exercise('', 'Incline Dumbbell Press (Nằm đẩy tạ đơn trên ghế dốc): 3 hiệp x 12-15 lần - Phát triển cơ ngực trên.', 'Trưa: Cơm gạo lứt, thịt ức gà luộc, canh rau cải.'),
		exercise('', 'Dumbbell Bench Press (Nằm đẩy tạ đơn): 3 hiệp x 12-15 lần - Phát triển cơ ngực.', 'Chiều: 1 cốc sinh tố whey protein với rau xanh.'),
		exercise('', 'Cable Crossovers (Kéo cáp ngực): 3 hiệp x 15-20 lần - Phát triển cơ ngực.', 'Tối: Thịt bò xào rau củ, 1 chén cơm gạo lứt.'),
		exercise('', 'Triceps Pushdowns (Đẩy tạ dây cáp xuống): 3 hiệp x 15-20 lần - Phát triển cơ tay sau.', ''),
		exercise('', 'Overhead Dumbbell Extensions (Duỗi tạ đơn qua đầu): 3 hiệp x 15-20 lần - Phát triển cơ tay sau.', ''),
		exercise('', 'Superset (Kết hợp 2 bài tập không nghỉ): Dips (Chống đẩy tay sau) 3 hiệp tối đa + Close-Grip Bench Press (Đẩy tạ đòn hẹp) 3 hiệp x 12-15 lần - Phát triển cơ tam đầu.', ''),

		exercise('Thứ 4: Lưng - Tay trước (Cường độ cao)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cám kẹp trứng và rau củ, sữa chua không đường.'),
		exercise('', 'Pull-ups (Kéo xà đơn): 3 hiệp, tối đa số lần có thể - Phát triển cơ lưng xô, cơ bắp tay trước.', 'Trưa: Cơm gạo lứt, cá diêu hồng hấp, rau luộc.'),
		exercise('', 'Lat Pulldowns (Kéo xà lat): 3 hiệp x 12-15 lần - Phát triển cơ lưng xô.', 'Chiều: 1 củ khoai lang luộc, 1 nắm hạt điều.'),
		exercise('', 'Seated Cable Rows (Chèo cáp ngồi): 3 hiệp x 15-20 lần - Phát triển cơ lưng giữa.', 'Tối: Súp gà nấm, salad rau trộn.'),
		exercise('', 'Dumbbell Bicep Curls (Cuốn tạ đơn): 3 hiệp x 12-15 lần - Phát triển cơ tay trước.', ''),
		exercise('', 'Hammer Curls (Cuốn tạ đơn kiểu búa): 3 hiệp x 12-15 lần - Phát triển cơ tay trước và cơ cẳng tay.', ''),
		exercise('', 'Barbell Curls (Cuốn tạ đòn): 3 hiệp x 10-12 lần - Phát triển cơ tay trước.', ''),

		exercise('Thứ 5: Cardio - Bụng (Cường độ trung bình)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát sữa chua không đường với hoa quả tươi và granola.'),
		exercise('', 'Chạy bộ trên máy (tốc độ vừa phải): 30 phút - Đốt mỡ thừa, tăng cường sức bền.', 'Trưa: Cơm gạo lứt, thịt lợn luộc, canh rau mồng tơi.'),
		exercise('', 'HIIT (High Intensity Interval Training) trên máy chạy bộ: Chạy nhanh 30 giây, đi bộ 30 giây, lặp lại 10-15 lần - Đốt mỡ thừa hiệu quả.', 'Chiều: Trái cây, 1 ít các loại hạt.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 20-25 lần - Phát triển cơ bụng trên.', 'Tối: Canh rau củ thập cẩm, đậu phụ hấp.'),
		exercise('', 'Leg Raises (Nâng chân): 3 hiệp x 20-25 lần - Phát triển cơ bụng dưới.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 60 giây - Tăng cường sức mạnh cơ core.', ''),
		exercise('', 'Russian Twists (Xoay người với tạ): 3 hiệp x 20-25 lần mỗi bên - Phát triển cơ bụng chéo.', ''),

		exercise('Thứ 6: Nghỉ ngơi', '', ''),

		exercise('Thứ 7: Toàn thân (Cường độ trung bình)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Trứng chiên rau củ, ngũ cốc granola với sữa.'),
		exercise('', 'Deadlifts (Nâng tạ đòn): 2 hiệp x 8-10 lần - Phát triển cơ lưng dưới, đùi sau, mông.', 'Trưa: Cơm gạo lứt, cá kho tộ, rau luộc.'),
		exercise('', 'Overhead Press (Đẩy tạ qua đầu): 2 hiệp x 10-12 lần - Phát triển cơ vai.', 'Chiều: Bánh protein, sữa đậu nành.'),
		exercise('', 'Dumbbell Bench Press (Nằm đẩy tạ đơn): 2 hiệp x 10-12 lần - Phát triển cơ ngực.', 'Tối: Thịt bò bít tết, khoai tây nghiền, salad.'),
		exercise('', 'Lat Pulldowns (Kéo xà lat): 2 hiệp x 12-15 lần - Phát triển cơ lưng.', ''),

		exercise('Chủ nhật: Cardio - Bụng (Cường độ thấp)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát cháo yến mạch với hoa quả tươi.'),
		exercise('', 'Đạp xe: 30 phút - Đốt mỡ thừa, thư giãn.', 'Trưa: Cơm gạo lứt, cá hấp, canh rau củ.'),
		exercise('', 'Crunches (Gập bụng): 2 hiệp x 15-20 lần - Duy trì cơ bụng.', 'Chiều: Sinh tố hoa quả ít đường.'),
		exercise('', 'Plank (Chống đẩy tĩnh): 2 hiệp, giữ tối đa 45 giây - Duy trì sức mạnh cơ core.', 'Tối: Salad rau trộn với tôm/ ức gà.')
	].
	
%Program15.1: Nam, Giảm cân, Tại nhà, 6 ngày
generate_fitness_program(Fullname, Age, he, Height, Weight, giamcan, Level, Type, home, sau, Program) :-
    Program = [
		exercise('Thứ 2: Toàn thân (Cường độ cao)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát yến mạch với sữa tươi không đường, hoa quả tươi và 1 ít hạt chia.'),
		exercise('', 'Jumping Jacks (Bật nhảy tại chỗ): 3 hiệp x 20 lần - Khởi động, tăng nhịp tim.', 'Trưa: 1 đĩa salad ức gà với rau củ quả (dầu giấm/ sốt mè rang), 1 củ khoai lang nhỏ luộc.'),
		exercise('', 'Burpees (Bài tập tổng hợp): 3 hiệp x 10-15 lần - Đốt mỡ, tăng sức mạnh và sức bền.', 'Chiều: 1 quả táo, 1 hũ sữa chua không đường.'),
		exercise('', 'Push-ups (Hít đất): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực, vai, tay sau.', 'Tối: Cá hồi nướng, rau củ hấp.'),
		exercise('', 'Squats (Gánh đùi): 3 hiệp x 15-20 lần - Đốt mỡ, phát triển cơ đùi trước, đùi sau, mông.', ''),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 20-25 lần - Phát triển cơ bụng trên.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 60 giây - Tăng cường sức mạnh cơ core.', ''),

		exercise('Thứ 3: Ngực - Tay sau', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 2 quả trứng luộc, 1 lát bánh mì đen nguyên cám, 1 quả chuối.'),
		exercise('', 'Push-ups (Hít đất): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực, vai trước và cơ tam đầu.', 'Trưa: Cơm gạo lứt, thịt ức gà luộc, canh rau cải.'),
		exercise('', 'Incline Push-ups (Chống đẩy trên ghế dốc): 3 hiệp x 12-15 lần - Phát triển cơ ngực trên, vai.', 'Chiều: 1 cốc sinh tố whey protein với rau xanh.'),
		exercise('', 'Dips (Chống đẩy tay sau) (có thể dùng ghế): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực dưới, cơ tam đầu.', 'Tối: Thịt bò xào rau củ, 1 chén cơm gạo lứt.'),

		exercise('Thứ 4: Chân - Vai', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cám kẹp trứng và rau củ, sữa chua không đường.'),
		exercise('', 'Squats (Gánh đùi): 3 hiệp x 15-20 lần - Phát triển cơ đùi trước, đùi sau, mông.', 'Trưa: Cơm gạo lứt, cá diêu hồng hấp, rau luộc.'),
		exercise('', 'Lunges (Chùng chân): 3 hiệp x 12-15 lần mỗi chân - Phát triển cơ đùi trước, mông, đùi sau.', 'Chiều: 1 củ khoai lang luộc, 1 nắm hạt điều.'),
		exercise('', 'Calf Raises (Nâng bắp chuối): 3 hiệp x 20-25 lần - Phát triển cơ bắp chân.', 'Tối: Súp gà nấm, salad rau trộn.'),
		exercise('', 'Shoulder Shrugs (Nhún vai) (có thể sử dụng tạ): 3 hiệp x 15-20 lần - Phát triển cơ vai.', ''),

		exercise('Thứ 5: Lưng - Tay trước', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát sữa chua không đường với hoa quả tươi và granola.'),
		exercise('', 'Pull-ups (Kéo xà đơn): 3 hiệp, tối đa số lần có thể - Phát triển cơ lưng xô, cơ bắp tay trước. (Nếu không có xà, có thể thay thế bằng các bài tập khác cho lưng xô như Superman, Good Morning)', 'Trưa: Cơm gạo lứt, thịt lợn luộc, canh rau mồng tơi.'),
		exercise('', 'Superman (Siêu nhân): 3 hiệp x 12-15 lần - Phát triển cơ lưng.', 'Chiều: Trái cây, 1 ít các loại hạt.'),
		exercise('', 'Reverse Snow Angels (Thiên thần ngược): 3 hiệp x 12-15 lần - Phát triển cơ lưng giữa.', 'Tối: Canh rau củ thập cẩm, đậu phụ hấp.'),
		exercise('', 'Bicep Curls (Cuốn tạ) (có thể sử dụng chai nước): 3 hiệp x 15-20 lần - Phát triển cơ tay trước.', ''),

		exercise('Thứ 6: Cardio - Bụng (Cường độ trung bình)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Trứng chiên rau củ, ngũ cốc granola với sữa.'),
		exercise('', 'Chạy bộ tại chỗ (high knees, butt kicks): 20-30 phút - Đốt mỡ thừa, tăng cường sức bền.', 'Trưa: Cơm gạo lứt, cá kho tộ, rau luộc.'),
		exercise('', 'Mountain Climbers (Leo núi): 3 hiệp x 30 giây - Bài tập cardio, tăng nhịp tim.', 'Chiều: Bánh protein, sữa đậu nành.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 20-25 lần - Phát triển cơ bụng trên.', 'Tối: Thịt bò bít tết, khoai tây nghiền, salad.'),
		exercise('', 'Leg Raises (Nâng chân): 3 hiệp x 20-25 lần - Phát triển cơ bụng dưới.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 60 giây - Tăng cường sức mạnh cơ core.', ''),
		exercise('', 'Russian Twists (Xoay người) (có thể dùng chai nước): 3 hiệp x 20-25 lần mỗi bên - Phát triển cơ bụng chéo.', ''),

		exercise('Thứ 7: Nghỉ ngơi', '', ''),

		exercise('Chủ nhật: Toàn thân (Cường độ thấp)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát cháo yến mạch với hoa quả tươi.'),
		exercise('', 'Jumping Jacks (Bật nhảy tại chỗ): 2 hiệp x 15 lần - Khởi động nhẹ nhàng.', 'Trưa: Cơm gạo lứt, cá hấp, canh rau củ.'),
		exercise('', 'Push-ups (Hít đất): 2 hiệp, tối đa số lần có thể - Duy trì sức mạnh cơ ngực.', 'Chiều: Sinh tố hoa quả ít đường.'),
		exercise('', 'Squats (Gánh đùi): 2 hiệp x 15-20 lần - Duy trì sức mạnh cơ chân.', 'Tối: Salad rau trộn với tôm/ ức gà.'),
		exercise('', 'Plank (Chống đẩy tĩnh): 2 hiệp, giữ tối đa 30 giây - Duy trì sức mạnh cơ core.', '')
	].
	

	
%Program16: Nữ, Giảm cân,Phòng gym, 6 ngày
generate_fitness_program(Fullname, Age, she, Height, Weight, giamcan, Level, Type, gym, sau, Program) :-
    Program = [
		exercise('Thứ 2: Chân - Vai (Cường độ cao)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát yến mạch với sữa tươi không đường, hoa quả tươi và 1 ít hạt chia.'),
		exercise('', 'Goblet Squats (Gánh tạ đơn trước ngực): 3 hiệp x 12-15 lần - Đốt mỡ, phát triển cơ đùi trước, đùi sau, mông.', 'Trưa: 1 đĩa salad ức gà với rau củ quả (dầu giấm/ sốt mè rang), 1 củ khoai lang nhỏ luộc.'),
		exercise('', 'Leg Press (Đạp tạ chân): 3 hiệp x 15-20 lần - Đốt mỡ, phát triển cơ đùi trước và mông.', 'Chiều: 1 quả táo, 1 hũ sữa chua không đường.'),
		exercise('', 'Glute Bridges (Nâng hông): 3 hiệp x 15-20 lần - Phát triển cơ mông và đùi sau.', 'Tối: Cá hồi nướng, rau củ hấp.'),
		exercise('', 'Standing Calf Raises (Nhón bắp chuối đứng): 3 hiệp x 20-25 lần - Phát triển cơ bắp chân.', ''),
		exercise('', 'Dumbbell Shoulder Press (Đẩy tạ đơn qua đầu): 3 hiệp x 12-15 lần - Phát triển cơ vai.', ''),
		exercise('', 'Lateral Raises (Nâng tạ sang ngang): 3 hiệp x 15-20 lần - Phát triển cơ vai giữa.', ''),

		exercise('Thứ 3: Ngực - Tay sau (Cường độ cao)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 2 quả trứng luộc, 1 lát bánh mì đen nguyên cám, 1 quả chuối.'),
		exercise('', 'Incline Dumbbell Press (Nằm đẩy tạ đơn trên ghế dốc): 3 hiệp x 12-15 lần - Phát triển cơ ngực trên.', 'Trưa: Cơm gạo lứt, thịt ức gà luộc, canh rau cải.'),
		exercise('', 'Dumbbell Bench Press (Nằm đẩy tạ đơn): 3 hiệp x 12-15 lần - Phát triển cơ ngực.', 'Chiều: 1 cốc sinh tố whey protein với rau xanh.'),
		exercise('', 'Cable Crossovers (Kéo cáp ngực): 3 hiệp x 15-20 lần - Phát triển cơ ngực.', 'Tối: Thịt bò xào rau củ, 1 chén cơm gạo lứt.'),
		exercise('', 'Triceps Pushdowns (Đẩy tạ dây cáp xuống): 3 hiệp x 15-20 lần - Phát triển cơ tay sau.', ''),
		exercise('', 'Overhead Dumbbell Extensions (Duỗi tạ đơn qua đầu): 3 hiệp x 15-20 lần - Phát triển cơ tay sau.', ''),

		exercise('Thứ 4: Lưng - Tay trước (Cường độ cao)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cám kẹp trứng và rau củ, sữa chua không đường.'),
		exercise('', 'Assisted Pull-ups (Kéo xà đơn với trợ lực) / Lat Pulldowns (Kéo xà lat): 3 hiệp x 12-15 lần - Phát triển cơ lưng xô, cơ bắp tay trước.', 'Trưa: Cơm gạo lứt, cá diêu hồng hấp, rau luộc.'),
		exercise('', 'Seated Cable Rows (Chèo cáp ngồi): 3 hiệp x 15-20 lần - Phát triển cơ lưng giữa.', 'Chiều: 1 củ khoai lang luộc, 1 nắm hạt điều.'),
		exercise('', 'Dumbbell Bicep Curls (Cuốn tạ đơn): 3 hiệp x 12-15 lần - Phát triển cơ tay trước.', 'Tối: Súp gà nấm, salad rau trộn.'),
		exercise('', 'Hammer Curls (Cuốn tạ đơn kiểu búa): 3 hiệp x 12-15 lần - Phát triển cơ tay trước và cơ cẳng tay.', ''),

		exercise('Thứ 5: Cardio - Bụng (Cường độ trung bình)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát sữa chua không đường với hoa quả tươi và granola.'),
		exercise('', 'Chạy bộ trên máy (tốc độ vừa phải): 30 phút - Đốt mỡ thừa, tăng cường sức bền.', 'Trưa: Cơm gạo lứt, thịt lợn luộc, canh rau mồng tơi.'),
		exercise('', 'HIIT (High Intensity Interval Training) trên máy chạy bộ: Chạy nhanh 30 giây, đi bộ 30 giây, lặp lại 10-15 lần - Đốt mỡ thừa hiệu quả.', 'Chiều: Trái cây, 1 ít các loại hạt.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 20-25 lần - Phát triển cơ bụng trên.', 'Tối: Canh rau củ thập cẩm, đậu phụ hấp.'),
		exercise('', 'Leg Raises (Nâng chân): 3 hiệp x 20-25 lần - Phát triển cơ bụng dưới.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 60 giây - Tăng cường sức mạnh cơ core.', ''),
		exercise('', 'Russian Twists (Xoay người với tạ): 3 hiệp x 20-25 lần mỗi bên - Phát triển cơ bụng chéo.', ''),

		exercise('Thứ 6: Toàn thân (Cường độ trung bình)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Trứng chiên rau củ, ngũ cốc granola với sữa.'),
		exercise('', 'Dumbbell Deadlifts (Nâng tạ đơn): 2 hiệp x 10-12 lần - Phát triển cơ lưng dưới, đùi sau, mông.', 'Trưa: Cơm gạo lứt, cá kho tộ, rau luộc.'),
		exercise('', 'Dumbbell Shoulder Press (Đẩy tạ đơn qua đầu): 2 hiệp x 10-12 lần - Phát triển cơ vai.', 'Chiều: Bánh protein, sữa đậu nành.'),
		exercise('', 'Dumbbell Bench Press (Nằm đẩy tạ đơn): 2 hiệp x 10-12 lần - Phát triển cơ ngực.', 'Tối: Thịt bò bít tết, khoai tây nghiền, salad.'),
		exercise('', 'Lat Pulldowns (Kéo xà lat): 2 hiệp x 12-15 lần - Phát triển cơ lưng.', ''),
		
		exercise('Thứ 7: Nghỉ ngơi', '', ''),

		exercise('Chủ nhật: Cardio - Bụng (Cường độ thấp)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát cháo yến mạch với hoa quả tươi (dâu tây, việt quất, chuối...).'),
		exercise('', 'Elliptical (Máy tập toàn thân): 30 phút - Đốt mỡ thừa, thư giãn.', 'Trưa: Cơm gạo lứt, cá hấp, canh rau củ.'),
		exercise('', 'Crunches (Gập bụng): 2 hiệp x 15-20 lần - Duy trì cơ bụng.', 'Chiều: Sinh tố hoa quả ít đường.'),
		exercise('', 'Plank (Chống đẩy tĩnh): 2 hiệp, giữ tối đa 45 giây - Duy trì sức mạnh cơ core.', 'Tối: Salad rau trộn với tôm/ ức gà.')
	].
%Program16.1: Nữ, Giảm cân,Tại nhà, 6 ngày
generate_fitness_program(Fullname, Age, she, Height, Weight, giamcan, Level, Type, home, sau, Program) :-
    Program = [
		exercise('Thứ 2: Toàn thân (Cường độ cao)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát yến mạch với sữa tươi không đường, hoa quả tươi và 1 ít hạt chia.'),
		exercise('', 'Jumping Jacks (Bật nhảy tại chỗ): 3 hiệp x 20 lần - Khởi động, tăng nhịp tim.', 'Trưa: 1 đĩa salad ức gà với rau củ quả (dầu giấm/ sốt mè rang), 1 củ khoai lang nhỏ luộc.'),
		exercise('', 'Burpees (Bài tập tổng hợp): 3 hiệp x 10-12 lần - Đốt mỡ, tăng sức mạnh và sức bền.', 'Chiều: 1 quả táo, 1 hũ sữa chua không đường.'),
		exercise('', 'Push-ups (Hít đất): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực, vai, tay sau.', 'Tối: Cá hồi nướng, rau củ hấp.'),
		exercise('', 'Squats (Gánh đùi): 3 hiệp x 15-20 lần - Đốt mỡ, phát triển cơ đùi trước, đùi sau, mông.', ''),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng trên.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 45 giây - Tăng cường sức mạnh cơ core.', ''),
		
		exercise('Thứ 3: Chân - Mông', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 2 quả trứng luộc, 1 lát bánh mì đen nguyên cám, 1 quả chuối.'),
		exercise('', 'Squats (Gánh đùi): 3 hiệp x 15-20 lần - Phát triển cơ đùi trước, đùi sau, mông.', 'Trưa: Cơm gạo lứt, thịt ức gà luộc, canh rau cải.'),
		exercise('', 'Lunges (Chùng chân): 3 hiệp x 12-15 lần mỗi chân - Phát triển cơ đùi trước, mông, đùi sau.', 'Chiều: 1 cốc sinh tố whey protein với rau xanh.'),
		exercise('', 'Glute Bridges (Nâng hông): 3 hiệp x 15-20 lần - Phát triển cơ mông.', 'Tối: Thịt bò xào rau củ, 1 chén cơm gạo lứt.'),
		exercise('', 'Calf Raises (Nâng bắp chuối): 3 hiệp x 20-25 lần - Phát triển cơ bắp chân.', ''),
		
		exercise('Thứ 4: Vai - Tay sau', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cám kẹp trứng và rau củ, sữa chua không đường.'),
		exercise('', 'Shoulder Taps (Chạm vai): 3 hiệp x 10-12 lần mỗi bên - Phát triển cơ vai, tăng cường ổn định.', 'Trưa: Cơm gạo lứt, cá diêu hồng hấp, rau luộc.'),
		exercise('', 'Pike Push-ups (Chống đẩy hình chữ V): 3 hiệp, tối đa số lần có thể - Phát triển cơ vai trước.', 'Chiều: 1 củ khoai lang luộc, 1 nắm hạt điều.'),
		exercise('', 'Triceps Dips (Chống đẩy tay sau) (có thể dùng ghế): 3 hiệp, tối đa số lần có thể - Phát triển cơ tay sau.', 'Tối: Súp gà nấm, salad rau trộn.'),
		
		exercise('Thứ 5: Lưng - Tay trước', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát sữa chua không đường với hoa quả tươi và granola.'),
		exercise('', 'Superman (Siêu nhân): 3 hiệp x 12-15 lần - Phát triển cơ lưng.', 'Trưa: Cơm gạo lứt, thịt lợn luộc, canh rau mồng tơi.'),
		exercise('', 'Reverse Snow Angels (Thiên thần ngược): 3 hiệp x 12-15 lần - Phát triển cơ lưng giữa.', 'Chiều: Trái cây, 1 ít các loại hạt.'),
		exercise('', 'Bicep Curls (Cuốn tạ) (có thể sử dụng chai nước): 3 hiệp x 15-20 lần - Phát triển cơ tay trước.', 'Tối: Canh rau củ thập cẩm, đậu phụ hấp.'),
		
		exercise('Thứ 6: Cardio - Bụng (Cường độ trung bình)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Trứng chiên rau củ, ngũ cốc granola với sữa.'),
		exercise('', 'Chạy bộ tại chỗ (high knees, butt kicks): 20-30 phút - Đốt mỡ thừa, tăng cường sức bền.', 'Trưa: Cơm gạo lứt, cá kho tộ, rau luộc.'),
		exercise('', 'Mountain Climbers (Leo núi): 3 hiệp x 30 giây - Bài tập cardio, tăng nhịp tim.', 'Chiều: Bánh protein, sữa đậu nành.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng trên.', 'Tối: Thịt bò bít tết, khoai tây nghiền, salad.'),
		exercise('', 'Leg Raises (Nâng chân): 3 hiệp x 15-20 lần - Phát triển cơ bụng dưới.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 45 giây - Tăng cường sức mạnh cơ core.', ''),
		exercise('', 'Russian Twists (Xoay người) (có thể dùng chai nước): 3 hiệp x 15-20 lần mỗi bên - Phát triển cơ bụng chéo.', ''),
		exercise('', 'Bicycle Crunches (Gập bụng xe đạp): 3 hiệp x 15-20 lần mỗi bên - Phát triển cơ bụng chéo.', ''),
		
		exercise('Thứ 7: Nghỉ ngơi', '', ''),
		
		exercise('Chủ nhật: Toàn thân (Cường độ thấp)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát cháo yến mạch với hoa quả tươi.'),
		exercise('', 'Jumping Jacks (Bật nhảy tại chỗ): 2 hiệp x 15 lần - Khởi động nhẹ nhàng.', 'Trưa: Cơm gạo lứt, cá hấp, canh rau củ.'),
		exercise('', 'Push-ups (Hít đất): 2 hiệp, tối đa số lần có thể - Duy trì sức mạnh cơ ngực.', 'Chiều: Sinh tố hoa quả ít đường.'),
		exercise('', 'Squats (Gánh đùi): 2 hiệp x 15-20 lần - Duy trì sức mạnh cơ chân.', 'Tối: Salad rau trộn với tôm/ ức gà.'),
		exercise('', 'Plank (Chống đẩy tĩnh): 2 hiệp, giữ tối đa 30 giây - Duy trì sức mạnh cơ core.', '')
	].

		

%Program17: Nữ, Giảm cân,Phòng gym, 5 ngày
generate_fitness_program(Fullname, Age, she, Height, Weight, giamcan, Level, Type, gym, nam, Program) :-
    Program = [
		exercise('Thứ 2: Chân - Vai (Cường độ cao)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát yến mạch với sữa tươi không đường, hoa quả tươi và 1 ít hạt chia.'),
		exercise('', 'Goblet Squats (Gánh tạ đơn trước ngực): 3 hiệp x 12-15 lần - Đốt mỡ, phát triển cơ đùi trước, đùi sau, mông.', 'Trưa: 1 đĩa salad ức gà với rau củ quả (dầu giấm/ sốt mè rang), 1 củ khoai lang nhỏ luộc.'),
		exercise('', 'Leg Press (Đạp tạ chân): 3 hiệp x 15-20 lần - Đốt mỡ, phát triển cơ đùi trước và mông.', 'Chiều: 1 quả táo, 1 hũ sữa chua không đường.'),
		exercise('', 'Glute Bridges (Nâng hông): 3 hiệp x 15-20 lần - Phát triển cơ mông và đùi sau.', 'Tối: Cá hồi nướng, rau củ hấp.'),
		exercise('', 'Standing Calf Raises (Nhón bắp chuối đứng): 3 hiệp x 20-25 lần - Phát triển cơ bắp chân.', ''),
		exercise('', 'Dumbbell Shoulder Press (Đẩy tạ đơn qua đầu): 3 hiệp x 12-15 lần - Phát triển cơ vai.', ''),
		exercise('', 'Lateral Raises (Nâng tạ sang ngang): 3 hiệp x 15-20 lần - Phát triển cơ vai giữa.', ''),

		exercise('Thứ 3: Ngực - Tay sau (Cường độ cao)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 2 quả trứng luộc, 1 lát bánh mì đen nguyên cám, 1 quả chuối.'),
		exercise('', 'Incline Dumbbell Press (Nằm đẩy tạ đơn trên ghế dốc): 3 hiệp x 12-15 lần - Phát triển cơ ngực trên.', 'Trưa: Cơm gạo lứt, thịt ức gà luộc, canh rau cải.'),
		exercise('', 'Dumbbell Bench Press (Nằm đẩy tạ đơn): 3 hiệp x 12-15 lần - Phát triển cơ ngực.', 'Chiều: 1 cốc sinh tố whey protein với rau xanh.'),
		exercise('', 'Cable Crossovers (Kéo cáp ngực): 3 hiệp x 15-20 lần - Phát triển cơ ngực.', 'Tối: Thịt bò xào rau củ, 1 chén cơm gạo lứt.'),
		exercise('', 'Triceps Pushdowns (Đẩy tạ dây cáp xuống): 3 hiệp x 15-20 lần - Phát triển cơ tay sau.', ''),
		exercise('', 'Overhead Dumbbell Extensions (Duỗi tạ đơn qua đầu): 3 hiệp x 15-20 lần - Phát triển cơ tay sau.', ''),

		exercise('Thứ 4: Lưng - Tay trước (Cường độ cao)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cám kẹp trứng và rau củ, sữa chua không đường.'),
		exercise('', 'Assisted Pull-ups (Kéo xà đơn với trợ lực) / Lat Pulldowns (Kéo xà lat): 3 hiệp x 12-15 lần - Phát triển cơ lưng xô, cơ bắp tay trước.', 'Trưa: Cơm gạo lứt, cá diêu hồng hấp, rau luộc.'),
		exercise('', 'Seated Cable Rows (Chèo cáp ngồi): 3 hiệp x 15-20 lần - Phát triển cơ lưng giữa.', 'Chiều: 1 củ khoai lang luộc, 1 nắm hạt điều.'),
		exercise('', 'Dumbbell Bicep Curls (Cuốn tạ đơn): 3 hiệp x 12-15 lần - Phát triển cơ tay trước.', 'Tối: Súp gà nấm, salad rau trộn.'),
		exercise('', 'Hammer Curls (Cuốn tạ đơn kiểu búa): 3 hiệp x 12-15 lần - Phát triển cơ tay trước và cơ cẳng tay.', ''),

		exercise('Thứ 5: Nghỉ ngơi', '', ''),

		exercise('Thứ 6: Toàn thân (Cường độ trung bình)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Trứng chiên rau củ, ngũ cốc granola với sữa.'),
		exercise('', 'Dumbbell Deadlifts (Nâng tạ đơn): 2 hiệp x 10-12 lần - Phát triển cơ lưng dưới, đùi sau, mông.', 'Trưa: Cơm gạo lứt, cá kho tộ, rau luộc.'),
		exercise('', 'Dumbbell Shoulder Press (Đẩy tạ đơn qua đầu): 2 hiệp x 10-12 lần - Phát triển cơ vai.', 'Chiều: Bánh protein, sữa đậu nành.'),
		exercise('', 'Dumbbell Bench Press (Nằm đẩy tạ đơn): 2 hiệp x 10-12 lần - Phát triển cơ ngực.', 'Tối: Thịt bò bít tết, khoai tây nghiền, salad.'),
		exercise('', 'Lat Pulldowns (Kéo xà lat): 2 hiệp x 12-15 lần - Phát triển cơ lưng.', ''),
		
		exercise('Thứ 7: Nghỉ ngơi', '', ''),

		exercise('Chủ nhật: Cardio - Bụng (Cường độ thấp)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát cháo yến mạch với hoa quả tươi (dâu tây, việt quất, chuối...).'),
		exercise('', 'Elliptical (Máy tập toàn thân): 30 phút - Đốt mỡ thừa, thư giãn.', 'Trưa: Cơm gạo lứt, cá hấp, canh rau củ.'),
		exercise('', 'Crunches (Gập bụng): 2 hiệp x 15-20 lần - Duy trì cơ bụng.', 'Chiều: Sinh tố hoa quả ít đường.'),
		exercise('', 'Plank (Chống đẩy tĩnh): 2 hiệp, giữ tối đa 45 giây - Duy trì sức mạnh cơ core.', 'Tối: Salad rau trộn với tôm/ ức gà.')
	].
%Program17.1: Nữ, Giảm cân,Tại nhà, 5 ngày
generate_fitness_program(Fullname, Age, she, Height, Weight, giamcan, Level, Type, home, nam, Program) :-
    Program = [
	
		exercise('Thứ 2: Toàn thân (Cường độ cao)', 'Jumping Jacks (Bật nhảy tại chỗ): 3 hiệp x 20 lần - Khởi động, tăng nhịp tim.', 'Sáng: 1 bát yến mạch với sữa tươi không đường, hoa quả tươi và 1 ít hạt chia.'),
		exercise('', 'Burpees (Bài tập tổng hợp): 3 hiệp x 8-10 lần - Đốt mỡ, tăng sức mạnh và sức bền.', 'Trưa: 1 đĩa salad ức gà với rau củ quả (dầu giấm/ sốt mè rang), 1 củ khoai lang nhỏ luộc.'),
		exercise('', 'Push-ups (Hít đất): 3 hiệp, tối đa số lần có thể (có thể chống đẩy trên tường nếu chưa hít đất được) - Phát triển cơ ngực, vai, tay sau.', 'Chiều: 1 quả táo, 1 hũ sữa chua không đường.'),
		exercise('', 'Squats (Gánh đùi): 3 hiệp x 12-15 lần - Đốt mỡ, phát triển cơ đùi trước, đùi sau, mông.', 'Tối: Cá hồi nướng, rau củ hấp.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng trên.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 30 giây - Tăng cường sức mạnh cơ core.', ''),

		
		exercise('Thứ 3: Chân - Mông', 'Squats (Gánh đùi): 3 hiệp x 15-20 lần - Phát triển cơ đùi trước, đùi sau, mông.', 'Sáng: 2 quả trứng luộc, 1 lát bánh mì đen nguyên cám, 1 quả chuối.'),
		exercise('', 'Lunges (Chùng chân): 3 hiệp x 10-12 lần mỗi chân - Phát triển cơ đùi trước, mông, đùi sau.', 'Trưa: Cơm gạo lứt, thịt ức gà luộc, canh rau cải.'),
		exercise('', 'Glute Bridges (Nâng hông): 3 hiệp x 12-15 lần - Phát triển cơ mông.', 'Chiều: 1 cốc sinh tố whey protein với rau xanh.'),
		exercise('', 'Calf Raises (Nâng bắp chuối): 3 hiệp x 15-20 lần - Phát triển cơ bắp chân.', 'Tối: Thịt bò xào rau củ, 1 chén cơm gạo lứt.'),

		
		exercise('Thứ 4: Nghỉ ngơi', '', ''),

		
		exercise('Thứ 5: Vai - Tay sau', 'Shoulder Taps (Chạm vai): 3 hiệp x 8-10 lần mỗi bên - Phát triển cơ vai, tăng cường ổn định.', 'Sáng: Bánh mì nguyên cám kẹp trứng và rau củ, sữa chua không đường.'),
		exercise('', 'Pike Push-ups (Chống đẩy hình chữ V): 3 hiệp, tối đa số lần có thể - Phát triển cơ vai trước.', 'Trưa: Cơm gạo lứt, cá diêu hồng hấp, rau luộc.'),
		exercise('', 'Triceps Dips (Chống đẩy tay sau) (có thể dùng ghế): 3 hiệp, tối đa số lần có thể - Phát triển cơ tay sau.', 'Chiều: 1 củ khoai lang luộc, 1 nắm hạt điều.'),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 40 giây - Tăng cường sức mạnh cơ core.', 'Tối: Súp gà nấm, salad rau trộn.'),

		
		exercise('Thứ 6: Lưng - Tay trước', 'Superman (Siêu nhân): 3 hiệp x 10-12 lần - Phát triển cơ lưng.', 'Sáng: 1 bát sữa chua không đường với hoa quả tươi và granola.'),
		exercise('', 'Reverse Snow Angels (Thiên thần ngược): 3 hiệp x 10-12 lần - Phát triển cơ lưng giữa.', 'Trưa: Cơm gạo lứt, thịt lợn luộc, canh rau mồng tơi.'),
		exercise('', 'Bicep Curls (Cuốn tạ) (có thể sử dụng chai nước): 3 hiệp x 12-15 lần - Phát triển cơ tay trước.', 'Chiều: Trái cây, 1 ít các loại hạt.'),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 40 giây - Tăng cường sức mạnh cơ core.', 'Tối: Canh rau củ thập cẩm, đậu phụ hấp.'),

		
		exercise('Thứ 7: Cardio - Bụng (Cường độ trung bình)', 'Chạy bộ tại chỗ (high knees, butt kicks): 20 phút - Đốt mỡ thừa, tăng cường sức bền.', 'Sáng: Trứng chiên rau củ, ngũ cốc granola với sữa.'),
		exercise('', 'Mountain Climbers (Leo núi): 3 hiệp x 30 giây - Bài tập cardio, tăng nhịp tim.', 'Trưa: Cơm gạo lứt, cá kho tộ, rau luộc.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng trên.', 'Chiều: Bánh protein, sữa đậu nành.'),
		exercise('', 'Leg Raises (Nâng chân): 3 hiệp x 15-20 lần - Phát triển cơ bụng dưới.', 'Tối: Thịt bò bít tết, khoai tây nghiền, salad.'),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 40 giây - Tăng cường sức mạnh cơ core.', ''),
		exercise('', 'Russian Twists (Xoay người) (có thể dùng chai nước): 3 hiệp x 15-20 lần mỗi bên - Phát triển cơ bụng chéo.', ''),
		exercise('', 'Bicycle Crunches (Gập bụng xe đạp): 3 hiệp x 12-15 lần mỗi bên - Phát triển cơ bụng chéo.', ''),

		
		exercise('Chủ nhật: Nghỉ ngơi', '', '')
	].

	

%Program18: Nữ, Giảm cân,phòng gym, 4 ngày
generate_fitness_program(Fullname, Age, she, Height, Weight, giamcan, Level, Type, gym, bon, Program) :-
    Program = [
		exercise('Thứ 2: Chân - Vai (Cường độ cao)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát yến mạch với sữa tươi không đường, hoa quả tươi và 1 ít hạt chia.'),
		exercise('', 'Goblet Squats (Gánh tạ đơn trước ngực): 3 hiệp x 12-15 lần - Đốt mỡ, phát triển cơ đùi trước, đùi sau, mông.', 'Trưa: 1 đĩa salad ức gà với rau củ quả (dầu giấm/ sốt mè rang), 1 củ khoai lang nhỏ luộc.'),
		exercise('', 'Leg Press (Đạp tạ chân): 3 hiệp x 15-20 lần - Đốt mỡ, phát triển cơ đùi trước và mông.', 'Chiều: 1 quả táo, 1 hũ sữa chua không đường.'),
		exercise('', 'Glute Bridges (Nâng hông): 3 hiệp x 15-20 lần - Phát triển cơ mông và đùi sau.', 'Tối: Cá hồi nướng, rau củ hấp.'),
		exercise('', 'Standing Calf Raises (Nhón bắp chuối đứng): 3 hiệp x 20-25 lần - Phát triển cơ bắp chân.', ''),
		exercise('', 'Dumbbell Shoulder Press (Đẩy tạ đơn qua đầu): 3 hiệp x 12-15 lần - Phát triển cơ vai.', ''),
		exercise('', 'Lateral Raises (Nâng tạ sang ngang): 3 hiệp x 15-20 lần - Phát triển cơ vai giữa.', ''),

		exercise('Thứ 3: Nghỉ ngơi', '', ''),

		exercise('Thứ 4: Lưng - Tay trước (Cường độ cao)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cám kẹp trứng và rau củ, sữa chua không đường.'),
		exercise('', 'Assisted Pull-ups (Kéo xà đơn với trợ lực) / Lat Pulldowns (Kéo xà lat): 3 hiệp x 12-15 lần - Phát triển cơ lưng xô, cơ bắp tay trước.', 'Trưa: Cơm gạo lứt, cá diêu hồng hấp, rau luộc.'),
		exercise('', 'Seated Cable Rows (Chèo cáp ngồi): 3 hiệp x 15-20 lần - Phát triển cơ lưng giữa.', 'Chiều: 1 củ khoai lang luộc, 1 nắm hạt điều.'),
		exercise('', 'Dumbbell Bicep Curls (Cuốn tạ đơn): 3 hiệp x 12-15 lần - Phát triển cơ tay trước.', 'Tối: Súp gà nấm, salad rau trộn.'),
		exercise('', 'Hammer Curls (Cuốn tạ đơn kiểu búa): 3 hiệp x 12-15 lần - Phát triển cơ tay trước và cơ cẳng tay.', ''),

		exercise('Thứ 5: Nghỉ ngơi', '', ''),

		exercise('Thứ 6: Toàn thân (Cường độ trung bình)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Trứng chiên rau củ, ngũ cốc granola với sữa.'),
		exercise('', 'Dumbbell Deadlifts (Nâng tạ đơn): 2 hiệp x 10-12 lần - Phát triển cơ lưng dưới, đùi sau, mông.', 'Trưa: Cơm gạo lứt, cá kho tộ, rau luộc.'),
		exercise('', 'Dumbbell Shoulder Press (Đẩy tạ đơn qua đầu): 2 hiệp x 10-12 lần - Phát triển cơ vai.', 'Chiều: Bánh protein, sữa đậu nành.'),
		exercise('', 'Dumbbell Bench Press (Nằm đẩy tạ đơn): 2 hiệp x 10-12 lần - Phát triển cơ ngực.', 'Tối: Thịt bò bít tết, khoai tây nghiền, salad.'),
		exercise('', 'Lat Pulldowns (Kéo xà lat): 2 hiệp x 12-15 lần - Phát triển cơ lưng.', ''),
		
		exercise('Thứ 7: Nghỉ ngơi', '', ''),

		exercise('Chủ nhật: Cardio - Bụng (Cường độ thấp)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát cháo yến mạch với hoa quả tươi (dâu tây, việt quất, chuối...).'),
		exercise('', 'Elliptical (Máy tập toàn thân): 30 phút - Đốt mỡ thừa, thư giãn.', 'Trưa: Cơm gạo lứt, cá hấp, canh rau củ.'),
		exercise('', 'Crunches (Gập bụng): 2 hiệp x 15-20 lần - Duy trì cơ bụng.', 'Chiều: Sinh tố hoa quả ít đường.'),
		exercise('', 'Plank (Chống đẩy tĩnh): 2 hiệp, giữ tối đa 45 giây - Duy trì sức mạnh cơ core.', 'Tối: Salad rau trộn với tôm/ ức gà.')
	].
%Program18.1: Nữ, Giảm cân,tại nhà, 4 ngày
generate_fitness_program(Fullname, Age, she, Height, Weight, giamcan, Level, Type, home, bon, Program) :-
    Program = [
		exercise('Thứ 2: Toàn thân (Cường độ cao)', 'Jumping Jacks (Bật nhảy tại chỗ): 3 hiệp x 20 lần - Khởi động, tăng nhịp tim.', 'Sáng: 1 bát yến mạch với sữa tươi không đường, hoa quả tươi và 1 ít hạt chia.'),
		exercise('', 'Burpees (Bài tập tổng hợp): 3 hiệp x 8-10 lần - Đốt mỡ, tăng sức mạnh và sức bền.', 'Trưa: 1 đĩa salad ức gà với rau củ quả (dầu giấm/ sốt mè rang), 1 củ khoai lang nhỏ luộc.'),
		exercise('', 'Push-ups (Hít đất): 3 hiệp, tối đa số lần có thể (có thể chống đẩy trên tường nếu chưa hít đất được) - Phát triển cơ ngực, vai, tay sau.', 'Chiều: 1 quả táo, 1 hũ sữa chua không đường.'),
		exercise('', 'Squats (Gánh đùi): 3 hiệp x 12-15 lần - Đốt mỡ, phát triển cơ đùi trước, đùi sau, mông.', 'Tối: Cá hồi nướng, rau củ hấp.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng trên.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 30 giây - Tăng cường sức mạnh cơ core.', ''),

		exercise('Thứ 3: Nghỉ ngơi', '', ''),

		exercise('Thứ 4: Chân - Mông (Cường độ cao)', 'Squats (Gánh đùi): 3 hiệp x 15-20 lần - Phát triển cơ đùi trước, đùi sau, mông.', 'Sáng: 2 quả trứng luộc, 1 lát bánh mì đen nguyên cám, 1 quả chuối.'),
		exercise('', 'Lunges (Chùng chân): 3 hiệp x 10-12 lần mỗi chân - Phát triển cơ đùi trước, mông, đùi sau.', 'Trưa: Cơm gạo lứt, thịt ức gà luộc, canh rau cải.'),
		exercise('', 'Glute Bridges (Nâng hông): 3 hiệp x 12-15 lần - Phát triển cơ mông.', 'Chiều: 1 cốc sinh tố whey protein với rau xanh.'),
		exercise('', 'Calf Raises (Nâng bắp chuối): 3 hiệp x 15-20 lần - Phát triển cơ bắp chân.', 'Tối: Thịt bò xào rau củ, 1 chén cơm gạo lứt.'),

		exercise('Thứ 5: Nghỉ ngơi', '', ''),

		exercise('Thứ 6: Vai - Tay sau (Cường độ cao)', 'Shoulder Taps (Chạm vai): 3 hiệp x 8-10 lần mỗi bên - Phát triển cơ vai, tăng cường ổn định.', 'Sáng: Bánh mì nguyên cám kẹp trứng và rau củ, sữa chua không đường.'),
		exercise('', 'Pike Push-ups (Chống đẩy hình chữ V): 3 hiệp, tối đa số lần có thể - Phát triển cơ vai trước.', 'Trưa: Cơm gạo lứt, cá diêu hồng hấp, rau luộc.'),
		exercise('', 'Triceps Dips (Chống đẩy tay sau) (có thể dùng ghế): 3 hiệp, tối đa số lần có thể - Phát triển cơ tay sau.', 'Chiều: 1 củ khoai lang luộc, 1 nắm hạt điều.'),
		exercise('', 'Reverse Flyes (Bài tập vai sau với tạ đơn/chai nước): 3 hiệp x 12-15 lần - Phát triển cơ vai sau.', 'Tối: Súp gà nấm, salad rau trộn.'),

		exercise('Thứ 7: Nghỉ ngơi', '', ''),

		exercise('Chủ nhật: Lưng - Tay trước - Bụng (Cường độ cao)', 'Superman (Siêu nhân): 3 hiệp x 10-12 lần - Phát triển cơ lưng.', 'Sáng: 1 bát sữa chua không đường với hoa quả tươi và granola.'),
		exercise('', 'Reverse Snow Angels (Thiên thần ngược): 3 hiệp x 10-12 lần - Phát triển cơ lưng giữa.', 'Trưa: Cơm gạo lứt, thịt lợn luộc, canh rau mồng tơi.'),
		exercise('', 'Bicep Curls (Cuốn tạ) (có thể sử dụng chai nước): 3 hiệp x 12-15 lần - Phát triển cơ tay trước.', 'Chiều: Trái cây, 1 ít các loại hạt.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng trên.', 'Tối: Canh rau củ thập cẩm, đậu phụ hấp.'),
		exercise('', 'Leg Raises (Nâng chân): 3 hiệp x 15-20 lần - Phát triển cơ bụng dưới.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 40 giây - Tăng cường sức mạnh cơ core.', ''),
		exercise('', 'Russian Twists (Xoay người) (có thể dùng chai nước): 3 hiệp x 15-20 lần mỗi bên - Phát triển cơ bụng chéo.', '')
	].

	
%Program19: Nữ, Tăng cân, phòng gym, 4 ngày
generate_fitness_program(Fullname, Age, she, Height, Weight, tangcan, Level, Type, gym, bon, Program) :-
    Program = [
		exercise('Thứ 2: Chân - Vai', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì sandwich trứng ốp la với phô mai và rau xà lách, sinh tố chuối bơ sữa.'),
		exercise('', 'Goblet Squats (Gánh tạ đơn trước ngực): 3 hiệp x 8-12 lần - Phát triển cơ đùi trước, đùi sau, mông.', 'Trưa: Cơm gạo lứt, thịt bò xào rau củ, canh rau.'),
		exercise('', 'Leg Press (Đạp tạ chân): 3 hiệp x 10-15 lần - Phát triển cơ đùi trước và mông.', 'Chiều: Sữa chua Hy Lạp với granola và hoa quả, các loại hạt.'),
		exercise('', 'Glute Bridges (Nâng hông): 3 hiệp x 12-15 lần - Phát triển cơ mông và đùi sau.', 'Tối: Gà nướng mật ong, khoai lang luộc, salad rau trộn.'),
		exercise('', 'Standing Calf Raises (Nhón bắp chuối đứng): 3 hiệp x 15-20 lần - Phát triển cơ bắp chân.', ''),
		exercise('', 'Dumbbell Shoulder Press (Đẩy tạ đơn qua đầu): 3 hiệp x 8-12 lần - Phát triển cơ vai.', ''),
		exercise('', 'Lateral Raises (Nâng tạ sang ngang): 3 hiệp x 12-15 lần - Phát triển cơ vai giữa.', ''),

		exercise('Thứ 3: Ngực - Tay sau', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Yến mạch với sữa tươi, hoa quả và hạt óc chó.'),
		exercise('', 'Incline Dumbbell Press (Nằm đẩy tạ đơn trên ghế dốc): 3 hiệp x 8-12 lần - Phát triển cơ ngực trên.', 'Trưa: Cơm gạo lứt, cá hồi nướng, rau củ luộc.'),
		exercise('', 'Dumbbell Bench Press (Nằm đẩy tạ đơn): 3 hiệp x 10-15 lần - Phát triển cơ ngực.', 'Chiều: Sinh tố whey protein với chuối và bơ đậu phộng.'),
		exercise('', 'Cable Crossovers (Kéo cáp ngực): 3 hiệp x 12-15 lần - Phát triển cơ ngực.', 'Tối: Mì ý sốt thịt bằm, salad cà chua dưa chuột.'),
		exercise('', 'Triceps Pushdowns (Đẩy tạ dây cáp xuống): 3 hiệp x 12-15 lần - Phát triển cơ tay sau.', ''),
		exercise('', 'Overhead Dumbbell Extensions (Duỗi tạ đơn qua đầu): 3 hiệp x 12-15 lần - Phát triển cơ tay sau.', ''),

		exercise('Thứ 4: Lưng - Tay trước', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cám kẹp trứng và bơ, sữa chua không đường với hoa quả.'),
		exercise('', 'Assisted Pull-ups (Kéo xà đơn với trợ lực) / Lat Pulldowns (Kéo xà lat): 3 hiệp x 8-12 lần - Phát triển cơ lưng xô, cơ bắp tay trước.', 'Trưa: Cơm gạo lứt, thịt heo luộc, canh bí đỏ.'),
		exercise('', 'Seated Cable Rows (Chèo cáp ngồi): 3 hiệp x 10-15 lần - Phát triển cơ lưng giữa.', 'Chiều: 1 quả chuối, 1 nắm hạt điều.'),
		exercise('', 'Dumbbell Bicep Curls (Cuốn tạ đơn): 3 hiệp x 10-15 lần - Phát triển cơ tay trước.', 'Tối: Súp gà nấm, bánh mì nướng bơ tỏi.'),
		exercise('', 'Hammer Curls (Cuốn tạ đơn kiểu búa): 3 hiệp x 10-15 lần - Phát triển cơ tay trước và cơ cẳng tay.', ''),

		exercise('Thứ 5: Nghỉ ngơi', '', ''),

		exercise('Thứ 6: Toàn thân (Cường độ trung bình)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Trứng chiên rau củ, ngũ cốc granola với sữa và mật ong.'),
		exercise('', 'Dumbbell Deadlifts (Nâng tạ đơn): 2 hiệp x 10-12 lần - Phát triển cơ lưng dưới, đùi sau, mông.', 'Trưa: Cơm gạo lứt, cá kho tộ, rau luộc.'),
		exercise('', 'Dumbbell Shoulder Press (Đẩy tạ đơn qua đầu): 2 hiệp x 10-12 lần - Phát triển cơ vai.', 'Chiều: Bánh protein, sữa đậu nành.'),
		exercise('', 'Dumbbell Bench Press (Nằm đẩy tạ đơn): 2 hiệp x 10-12 lần - Phát triển cơ ngực.', 'Tối: Thịt bò bít tết, khoai tây nghiền, salad.'),

		exercise('Thứ 7: Nghỉ ngơi', '', ''),

		exercise('Chủ nhật: Nghỉ ngơi', '', '')
	].
%Program19.1: Nữ, Tăng cân, tại nhà, 4 ngày
generate_fitness_program(Fullname, Age, she, Height, Weight, tangcan, Level, Type, home, bon, Program) :-
    Program = [
		exercise('Thứ 2: Toàn thân (Cường độ cao)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì sandwich trứng ốp la với phô mai và rau xà lách, sinh tố chuối bơ sữa.'),
		exercise('', 'Jumping Jacks (Bật nhảy tại chỗ): 3 hiệp x 20 lần - Khởi động, tăng nhịp tim.', 'Trưa: Cơm gạo lứt, thịt bò xào rau củ, canh rau.'),
		exercise('', 'Burpees (Bài tập tổng hợp): 3 hiệp x 8-10 lần - Tăng sức mạnh và sức bền.', 'Chiều: Sữa chua Hy Lạp với granola và hoa quả, các loại hạt.'),
		exercise('', 'Push-ups (Hít đất): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực, vai, tay sau.', 'Tối: Gà nướng mật ong, khoai tây nướng, salad rau trộn.'),
		exercise('', 'Squats (Gánh đùi): 3 hiệp x 12-15 lần - Phát triển cơ đùi trước, đùi sau, mông.', ''),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng trên.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 30 giây - Tăng cường sức mạnh cơ core.', ''),

		exercise('Thứ 3: Nghỉ ngơi', '', ''),

		exercise('Thứ 4: Chân - Mông (Cường độ cao)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Yến mạch với sữa tươi, hoa quả và hạt óc chó.'),
		exercise('', 'Squats (Gánh đùi): 3 hiệp x 15-20 lần - Phát triển cơ đùi trước, đùi sau, mông.', 'Trưa: Cơm gạo lứt, cá hồi nướng, rau củ luộc.'),
		exercise('', 'Lunges (Chùng chân): 3 hiệp x 10-12 lần mỗi chân - Phát triển cơ đùi trước, mông, đùi sau.', 'Chiều: Sinh tố whey protein với chuối và bơ đậu phộng.'),
		exercise('', 'Glute Bridges (Nâng hông): 3 hiệp x 12-15 lần - Phát triển cơ mông.', 'Tối: Mì ý sốt thịt bằm, salad cà chua dưa chuột.'),
		exercise('', 'Calf Raises (Nâng bắp chuối): 3 hiệp x 15-20 lần - Phát triển cơ bắp chân.', ''),

		exercise('Thứ 5: Nghỉ ngơi', '', ''),

		exercise('Thứ 6: Vai - Tay sau (Cường độ cao)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cám kẹp trứng và bơ, sữa chua không đường với hoa quả.'),
		exercise('', 'Shoulder Taps (Chạm vai): 3 hiệp x 8-10 lần mỗi bên - Phát triển cơ vai, tăng cường ổn định.', 'Trưa: Cơm gạo lứt, thịt heo luộc, canh bí đỏ.'),
		exercise('', 'Pike Push-ups (Chống đẩy hình chữ V): 3 hiệp, tối đa số lần có thể - Phát triển cơ vai trước.', 'Chiều: 1 quả chuối, 1 nắm hạt điều.'),
		exercise('', 'Triceps Dips (Chống đẩy tay sau) (có thể dùng ghế): 3 hiệp, tối đa số lần có thể - Phát triển cơ tay sau.', 'Tối: Súp gà nấm, bánh mì nướng bơ tỏi.'),
		exercise('', 'Reverse Flyes (Bài tập vai sau với tạ đơn/chai nước): 3 hiệp x 12-15 lần - Phát triển cơ vai sau.', ''),

		exercise('Thứ 7: Nghỉ ngơi', '', ''),

		exercise('Chủ nhật: Lưng - Tay trước - Bụng (Cường độ trung bình)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: 1 bát sữa chua không đường với hoa quả tươi và granola.'),
		exercise('', 'Superman (Siêu nhân): 3 hiệp x 10-12 lần - Phát triển cơ lưng.', 'Trưa: Cơm gạo lứt, thịt lợn luộc, canh rau mồng tơi.'),
		exercise('', 'Reverse Snow Angels (Thiên thần ngược): 3 hiệp x 10-12 lần - Phát triển cơ lưng giữa.', 'Chiều: Trái cây, 1 ít các loại hạt.'),
		exercise('', 'Bicep Curls (Cuốn tạ) (có thể sử dụng chai nước): 3 hiệp x 12-15 lần - Phát triển cơ tay trước.', 'Tối: Canh rau củ thập cẩm, đậu phụ hấp.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng trên.', ''),
		exercise('', 'Leg Raises (Nâng chân): 3 hiệp x 15-20 lần - Phát triển cơ bụng dưới.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 40 giây - Tăng cường sức mạnh cơ core.', ''),
		exercise('', 'Russian Twists (Xoay người) (có thể dùng chai nước): 3 hiệp x 15-20 lần mỗi bên - Phát triển cơ bụng chéo.', '')
	].

	
%Program20: Nữ, Tăng cân,Phòng gym, 5 ngày
generate_fitness_program(Fullname, Age, she, Height, Weight, tangcan, Level, Type, gym, nam, Program) :-	
	Program = [
		exercise('Thứ 2: Chân - Vai', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì sandwich trứng ốp la với phô mai và rau xà lách, sinh tố chuối bơ sữa.'),
		exercise('', 'Goblet Squats (Gánh tạ đơn trước ngực): 3 hiệp x 8-12 lần - Phát triển cơ đùi trước, đùi sau, mông.', 'Trưa: Cơm gạo lứt, thịt bò xào rau củ, canh rau.'),
		exercise('', 'Leg Press (Đạp tạ chân): 3 hiệp x 10-15 lần - Phát triển cơ đùi trước và mông.', 'Chiều: Sữa chua Hy Lạp với granola và hoa quả, các loại hạt.'),
		exercise('', 'Glute Bridges (Nâng hông): 3 hiệp x 12-15 lần - Phát triển cơ mông và đùi sau.', 'Tối: Gà nướng mật ong, khoai lang luộc, salad rau trộn.'),
		exercise('', 'Standing Calf Raises (Nhón bắp chuối đứng): 3 hiệp x 15-20 lần - Phát triển cơ bắp chân.', ''),
		exercise('', 'Dumbbell Shoulder Press (Đẩy tạ đơn qua đầu): 3 hiệp x 8-12 lần - Phát triển cơ vai.', ''),
		exercise('', 'Lateral Raises (Nâng tạ sang ngang): 3 hiệp x 12-15 lần - Phát triển cơ vai giữa.', ''),
		
		exercise('Thứ 3: Ngực - Tay sau', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Yến mạch với sữa tươi, hoa quả và hạt óc chó.'),
		exercise('', 'Incline Dumbbell Press (Nằm đẩy tạ đơn trên ghế dốc): 3 hiệp x 8-12 lần - Phát triển cơ ngực trên.', 'Trưa: Cơm gạo lứt, cá hồi nướng, rau củ luộc.'),
		exercise('', 'Dumbbell Bench Press (Nằm đẩy tạ đơn): 3 hiệp x 10-15 lần - Phát triển cơ ngực.', 'Chiều: Sinh tố whey protein với chuối và bơ đậu phộng.'),
		exercise('', 'Cable Crossovers (Kéo cáp ngực): 3 hiệp x 12-15 lần - Phát triển cơ ngực.', 'Tối: Mì ý sốt thịt bằm, salad cà chua dưa chuột.'),
		exercise('', 'Triceps Pushdowns (Đẩy tạ dây cáp xuống): 3 hiệp x 12-15 lần - Phát triển cơ tay sau.', ''),
		exercise('', 'Overhead Dumbbell Extensions (Duỗi tạ đơn qua đầu): 3 hiệp x 12-15 lần - Phát triển cơ tay sau.', ''),
		
		exercise('Thứ 4: Lưng - Tay trước', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cám kẹp trứng và bơ, sữa chua không đường với hoa quả.'),
		exercise('', 'Assisted Pull-ups (Kéo xà đơn với trợ lực) / Lat Pulldowns (Kéo xà lat): 3 hiệp x 8-12 lần - Phát triển cơ lưng xô, cơ bắp tay trước.', 'Trưa: Cơm gạo lứt, thịt heo luộc, canh bí đỏ.'),
		exercise('', 'Seated Cable Rows (Chèo cáp ngồi): 3 hiệp x 10-15 lần - Phát triển cơ lưng giữa.', 'Chiều: 1 quả chuối, 1 nắm hạt điều.'),
		exercise('', 'Dumbbell Bicep Curls (Cuốn tạ đơn): 3 hiệp x 10-15 lần - Phát triển cơ tay trước.', 'Tối: Súp gà nấm, bánh mì nướng bơ tỏi.'),
		exercise('', 'Hammer Curls (Cuốn tạ đơn kiểu búa): 3 hiệp x 10-15 lần - Phát triển cơ tay trước và cơ cẳng tay.', ''),
		
		exercise('Thứ 5: Toàn thân (Cường độ trung bình)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Trứng chiên rau củ, ngũ cốc granola với sữa và mật ong.'),
		exercise('', 'Dumbbell Deadlifts (Nâng tạ đơn): 2 hiệp x 10-12 lần - Phát triển cơ lưng dưới, đùi sau, mông.', 'Trưa: Cơm gạo lứt, cá kho tộ, rau luộc.'),
		exercise('', 'Dumbbell Shoulder Press (Đẩy tạ đơn qua đầu): 2 hiệp x 10-12 lần - Phát triển cơ vai.', 'Chiều: Bánh protein, sữa đậu nành.'),
		exercise('', 'Dumbbell Bench Press (Nằm đẩy tạ đơn): 2 hiệp x 10-12 lần - Phát triển cơ ngực.', 'Tối: Thịt bò bít tết, khoai tây nghiền, salad.'),
		exercise('', 'Lat Pulldowns (Kéo xà lat): 2 hiệp x 12-15 lần - Phát triển cơ lưng.', ''),
		
		exercise('Thứ 6: Bụng - Cardio nhẹ nhàng', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Pancake chuối yến mạch, mật ong.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng trên.', 'Trưa: Cơm gạo lứt, canh chua cá, rau luộc.'),
		exercise('', 'Leg Raises (Nâng chân): 3 hiệp x 15-20 lần - Phát triển cơ bụng dưới.', 'Chiều: Sinh tố bơ.'),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 45 giây - Tăng cường sức mạnh cơ core.', 'Tối: Bún chả, nem.'),
		exercise('', 'Russian Twists (Xoay người với tạ): 3 hiệp x 15-20 lần mỗi bên - Phát triển cơ bụng chéo.', ''),
		exercise('', 'Đi bộ trên máy/ngoài trời: 30 phút - Thư giãn, đốt mỡ nhẹ nhàng, tăng cường sức khỏe tim mạch.', ''),
		
		exercise('Thứ 7', 'Nghỉ ngơi', ''),
		
		exercise('Chủ nhật', 'Nghỉ ngơi', '')
	].
%Program20.1: Nữ, Tăng cân,tại nhà, 5 ngày
generate_fitness_program(Fullname, Age, she, Height, Weight, tangcan, Level, Type, home, nam, Program) :-	
	Program = [
		exercise('Thứ 2: Toàn thân', 'Jumping Jacks (Bật nhảy tại chỗ): 3 hiệp x 20 lần - Khởi động, tăng nhịp tim.', 'Sáng: Bánh mì sandwich trứng ốp la với phô mai và rau xà lách, sinh tố chuối bơ sữa.'),
		exercise('', 'Burpees (Bài tập tổng hợp): 3 hiệp x 8-10 lần - Tăng sức mạnh và sức bền.', 'Trưa: Cơm gạo lứt, thịt bò xào rau củ, canh rau.'),
		exercise('', 'Push-ups (Hít đất): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực, vai, tay sau.', 'Chiều: Sữa chua Hy Lạp với granola và hoa quả, các loại hạt.'),
		exercise('', 'Squats (Gánh đùi): 3 hiệp x 12-15 lần - Phát triển cơ đùi trước, đùi sau, mông.', 'Tối: Gà nướng mật ong, khoai tây nướng, salad rau trộn.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng trên.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 30 giây - Tăng cường sức mạnh cơ core.', ''),

		exercise('Thứ 3: Chân - Mông', 'Squats (Gánh đùi): 3 hiệp x 15-20 lần - Phát triển cơ đùi trước, đùi sau, mông.', 'Sáng: 2 quả trứng luộc, 1 lát bánh mì đen nguyên cám, 1 quả chuối.'),
		exercise('', 'Lunges (Chùng chân): 3 hiệp x 10-12 lần mỗi chân - Phát triển cơ đùi trước, mông, đùi sau.', 'Trưa: Cơm gạo lứt, thịt ức gà luộc, canh rau cải.'),
		exercise('', 'Glute Bridges (Nâng hông): 3 hiệp x 12-15 lần - Phát triển cơ mông.', 'Chiều: 1 cốc sinh tố whey protein với rau xanh.'),
		exercise('', 'Calf Raises (Nâng bắp chuối): 3 hiệp x 15-20 lần - Phát triển cơ bắp chân.', 'Tối: Thịt bò xào rau củ, 1 chén cơm gạo lứt.'),

		exercise('Thứ 4: Nghỉ ngơi', '', ''),

		exercise('Thứ 5: Vai - Tay sau', 'Shoulder Taps (Chạm vai): 3 hiệp x 8-10 lần mỗi bên - Phát triển cơ vai, tăng cường ổn định.', 'Sáng: Bánh mì nguyên cám kẹp trứng và bơ, sữa chua không đường với hoa quả.'),
		exercise('', 'Pike Push-ups (Chống đẩy hình chữ V): 3 hiệp, tối đa số lần có thể - Phát triển cơ vai trước.', 'Trưa: Cơm gạo lứt, thịt heo luộc, canh bí đỏ.'),
		exercise('', 'Triceps Dips (Chống đẩy tay sau) (có thể dùng ghế): 3 hiệp, tối đa số lần có thể - Phát triển cơ tay sau.', 'Chiều: 1 quả chuối, 1 nắm hạt điều.'),
		exercise('', 'Reverse Flyes (Bài tập vai sau với tạ đơn/chai nước): 3 hiệp x 12-15 lần - Phát triển cơ vai sau.', 'Tối: Súp gà nấm, bánh mì nướng bơ tỏi.'),

		exercise('Thứ 6: Lưng - Tay trước', 'Superman (Siêu nhân): 3 hiệp x 10-12 lần - Phát triển cơ lưng.', 'Sáng: 1 bát sữa chua không đường với hoa quả tươi và granola.'),
		exercise('', 'Reverse Snow Angels (Thiên thần ngược): 3 hiệp x 10-12 lần - Phát triển cơ lưng giữa.', 'Trưa: Cơm gạo lứt, thịt lợn luộc, canh rau mồng tơi.'),
		exercise('', 'Bicep Curls (Cuốn tạ) (có thể sử dụng chai nước): 3 hiệp x 12-15 lần - Phát triển cơ tay trước.', 'Chiều: Trái cây, 1 ít các loại hạt.'),
		exercise('', '', 'Tối: Canh rau củ thập cẩm, đậu phụ hấp.'),

		exercise('Thứ 7: Cardio - Bụng (Cường độ trung bình)', 'Chạy bộ tại chỗ (high knees, butt kicks): 20 phút - Đốt mỡ thừa, tăng cường sức bền.', 'Sáng: Trứng chiên rau củ, ngũ cốc granola với sữa.'),
		exercise('', 'Mountain Climbers (Leo núi): 3 hiệp x 30 giây - Bài tập cardio, tăng nhịp tim.', 'Trưa: Cơm gạo lứt, cá kho tộ, rau luộc.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng trên.', 'Chiều: Bánh protein, sữa đậu nành.'),
		exercise('', 'Leg Raises (Nâng chân): 3 hiệp x 15-20 lần - Phát triển cơ bụng dưới.', 'Tối: Thịt bò bít tết, khoai tây nghiền, salad.'),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 40 giây - Tăng cường sức mạnh cơ core.', ''),
		exercise('', 'Russian Twists (Xoay người) (có thể dùng chai nước): 3 hiệp x 15-20 lần mỗi bên - Phát triển cơ bụng chéo.', ''),
		exercise('', 'Bicycle Crunches (Gập bụng xe đạp): 3 hiệp x 12-15 lần mỗi bên - Phát triển cơ bụng chéo.', ''),

		exercise('Chủ nhật: Nghỉ ngơi', '', '')
	].

	
%Program21: Nữ, Tăng cân,phòng gym 6 ngày
generate_fitness_program(Fullname, Age, she, Height, Weight, tangcan, Level, Type, gym, sau, Program) :-	
	Program = [
		exercise('Thứ 2: Chân - Vai', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì sandwich trứng ốp la với phô mai và rau xà lách, sinh tố chuối bơ sữa.'),
		exercise('', 'Goblet Squats (Gánh tạ đơn trước ngực): 3 hiệp x 8-12 lần - Phát triển cơ đùi trước, đùi sau, mông.', 'Trưa: Cơm gạo lứt, thịt bò xào rau củ, canh rau.'),
		exercise('', 'Leg Press (Đạp tạ chân): 3 hiệp x 10-15 lần - Phát triển cơ đùi trước và mông.', 'Chiều: Sữa chua Hy Lạp với granola và hoa quả, các loại hạt.'),
		exercise('', 'Glute Bridges (Nâng hông): 3 hiệp x 12-15 lần - Phát triển cơ mông và đùi sau.', 'Tối: Gà nướng mật ong, khoai lang luộc, salad rau trộn.'),
		exercise('', 'Standing Calf Raises (Nhón bắp chuối đứng): 3 hiệp x 15-20 lần - Phát triển cơ bắp chân.', ''),
		exercise('', 'Dumbbell Shoulder Press (Đẩy tạ đơn qua đầu): 3 hiệp x 8-12 lần - Phát triển cơ vai.', ''),
		exercise('', 'Lateral Raises (Nâng tạ sang ngang): 3 hiệp x 12-15 lần - Phát triển cơ vai giữa.', ''),
		
		exercise('Thứ 3: Ngực - Tay sau', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Yến mạch với sữa tươi, hoa quả và hạt óc chó.'),
		exercise('', 'Incline Dumbbell Press (Nằm đẩy tạ đơn trên ghế dốc): 3 hiệp x 8-12 lần - Phát triển cơ ngực trên.', 'Trưa: Cơm gạo lứt, cá hồi nướng, rau củ luộc.'),
		exercise('', 'Dumbbell Bench Press (Nằm đẩy tạ đơn): 3 hiệp x 10-15 lần - Phát triển cơ ngực.', 'Chiều: Sinh tố whey protein với chuối và bơ đậu phộng.'),
		exercise('', 'Cable Crossovers (Kéo cáp ngực): 3 hiệp x 12-15 lần - Phát triển cơ ngực.', 'Tối: Mì ý sốt thịt bằm, salad cà chua dưa chuột.'),
		exercise('', 'Triceps Pushdowns (Đẩy tạ dây cáp xuống): 3 hiệp x 12-15 lần - Phát triển cơ tay sau.', ''),
		exercise('', 'Overhead Dumbbell Extensions (Duỗi tạ đơn qua đầu): 3 hiệp x 12-15 lần - Phát triển cơ tay sau.', ''),

		exercise('Thứ 4: Lưng - Tay trước', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Bánh mì nguyên cám kẹp trứng và bơ, sữa chua không đường với hoa quả.'),
		exercise('', 'Assisted Pull-ups (Kéo xà đơn với trợ lực) / Lat Pulldowns (Kéo xà lat): 3 hiệp x 8-12 lần - Phát triển cơ lưng xô, cơ bắp tay trước.', 'Trưa: Cơm gạo lứt, thịt heo luộc, canh bí đỏ.'),
		exercise('', 'Seated Cable Rows (Chèo cáp ngồi): 3 hiệp x 10-15 lần - Phát triển cơ lưng giữa.', 'Chiều: 1 quả chuối, 1 nắm hạt điều.'),
		exercise('', 'Dumbbell Bicep Curls (Cuốn tạ đơn): 3 hiệp x 10-15 lần - Phát triển cơ tay trước.', 'Tối: Súp gà nấm, bánh mì nướng bơ tỏi.'),
		exercise('', 'Hammer Curls (Cuốn tạ đơn kiểu búa): 3 hiệp x 10-15 lần - Phát triển cơ tay trước và cơ cẳng tay.', ''),

		exercise('Thứ 5: Toàn thân (Cường độ trung bình)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Trứng chiên rau củ, ngũ cốc granola với sữa và mật ong.'),
		exercise('', 'Dumbbell Deadlifts (Nâng tạ đơn): 2 hiệp x 10-12 lần - Phát triển cơ lưng dưới, đùi sau, mông.', 'Trưa: Cơm gạo lứt, cá kho tộ, rau luộc.'),
		exercise('', 'Dumbbell Shoulder Press (Đẩy tạ đơn qua đầu): 2 hiệp x 10-12 lần - Phát triển cơ vai.', 'Chiều: Bánh protein, sữa đậu nành.'),
		exercise('', 'Dumbbell Bench Press (Nằm đẩy tạ đơn): 2 hiệp x 10-12 lần - Phát triển cơ ngực.', 'Tối: Thịt bò bít tết, khoai tây nghiền, salad.'),
		exercise('', 'Lat Pulldowns (Kéo xà lat): 2 hiệp x 12-15 lần - Phát triển cơ lưng.', ''),

		exercise('Thứ 6: Bụng - Cardio nhẹ nhàng', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Pancake chuối yến mạch, mật ong.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng trên.', 'Trưa: Cơm gạo lứt, canh chua cá, rau luộc.'),
		exercise('', 'Leg Raises (Nâng chân): 3 hiệp x 15-20 lần - Phát triển cơ bụng dưới.', 'Chiều: Sinh tố bơ.'),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 45 giây - Tăng cường sức mạnh cơ core.', 'Tối: Bún chả, nem.'),
		exercise('', 'Russian Twists (Xoay người với tạ): 3 hiệp x 15-20 lần mỗi bên - Phát triển cơ bụng chéo.', ''),
		exercise('', 'Đi bộ trên máy/ ngoài trời: 30 phút - Thư giãn, đốt mỡ nhẹ nhàng, tăng cường sức khỏe tim mạch.', ''),

		exercise('Thứ 7: Vai - Tay sau (Cường độ trung bình)', 'Khởi động kỹ (5-10 phút cardio nhẹ và giãn cơ động).', 'Sáng: Cháo gà, trứng luộc.'),
		exercise('', 'Front Raises (Nâng tạ trước mặt): 3 hiệp x 12-15 lần - Phát triển cơ vai trước.', 'Trưa: Cơm gạo lứt, cá thu rim, canh chua.'),
		exercise('', 'Rear Delt Flyes (Bài tập vai sau): 3 hiệp x 12-15 lần - Phát triển cơ vai sau.', 'Chiều: Trái cây, sữa chua.'),
		exercise('', 'Triceps Extensions (Duỗi tay sau với tạ đơn): 3 hiệp x 12-15 lần - Phát triển cơ tay sau.', 'Tối: Cơm tấm sườn bì chả, canh khổ qua.'),
		
		exercise('Chủ nhật', 'Nghỉ ngơi', '')
	].
%Program21.1: Nữ, Tăng cân,tại nhà, 6 ngày
generate_fitness_program(Fullname, Age, she, Height, Weight, tangcan, Level, Type, home, sau, Program) :-	
	Program = [
		exercise('Thứ 2: Toàn thân', 'Jumping Jacks (Bật nhảy tại chỗ): 3 hiệp x 20 lần - Khởi động, tăng nhịp tim.', 'Sáng: Bánh mì sandwich trứng ốp la với phô mai và rau xà lách, sinh tố chuối bơ sữa.'),
		exercise('', 'Burpees (Bài tập tổng hợp): 3 hiệp x 8-10 lần - Tăng sức mạnh và sức bền.', 'Trưa: Cơm gạo lứt, thịt bò xào rau củ, canh rau.'),
		exercise('', 'Push-ups (Hít đất): 3 hiệp, tối đa số lần có thể - Phát triển cơ ngực, vai, tay sau.', 'Chiều: Sữa chua Hy Lạp với granola và hoa quả, các loại hạt.'),
		exercise('', 'Squats (Gánh đùi): 3 hiệp x 12-15 lần - Phát triển cơ đùi trước, đùi sau, mông.', 'Tối: Gà nướng mật ong, khoai tây nướng, salad rau trộn.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng trên.', ''),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 30 giây - Tăng cường sức mạnh cơ core.', ''),

		exercise('Thứ 3: Chân - Mông', 'Squats (Gánh đùi): 3 hiệp x 15-20 lần - Phát triển cơ đùi trước, đùi sau, mông.', 'Sáng: 2 quả trứng luộc, 1 lát bánh mì đen nguyên cám, 1 quả chuối.'),
		exercise('', 'Lunges (Chùng chân): 3 hiệp x 10-12 lần mỗi chân - Phát triển cơ đùi trước, mông, đùi sau.', 'Trưa: Cơm gạo lứt, thịt ức gà luộc, canh rau cải.'),
		exercise('', 'Glute Bridges (Nâng hông): 3 hiệp x 12-15 lần - Phát triển cơ mông.', 'Chiều: 1 cốc sinh tố whey protein với rau xanh.'),
		exercise('', 'Calf Raises (Nâng bắp chuối): 3 hiệp x 15-20 lần - Phát triển cơ bắp chân.', 'Tối: Thịt bò xào rau củ, 1 chén cơm gạo lứt.'),

		exercise('Thứ 4: Vai - Tay sau', 'Shoulder Taps (Chạm vai): 3 hiệp x 8-10 lần mỗi bên - Phát triển cơ vai, tăng cường ổn định.', 'Sáng: Bánh mì nguyên cám kẹp trứng và bơ, sữa chua không đường với hoa quả.'),
		exercise('', 'Pike Push-ups (Chống đẩy hình chữ V): 3 hiệp, tối đa số lần có thể - Phát triển cơ vai trước.', 'Trưa: Cơm gạo lứt, thịt heo luộc, canh bí đỏ.'),
		exercise('', 'Triceps Dips (Chống đẩy tay sau): 3 hiệp, tối đa số lần có thể - Phát triển cơ tay sau.', 'Chiều: 1 quả chuối, 1 nắm hạt điều.'),
		exercise('', 'Reverse Flyes (Bài tập vai sau với tạ đơn): 3 hiệp x 12-15 lần - Phát triển cơ vai sau.', 'Tối: Súp gà nấm, bánh mì nướng bơ tỏi.'),

		exercise('Thứ 5: Lưng - Tay trước', 'Superman (Siêu nhân): 3 hiệp x 10-12 lần - Phát triển cơ lưng.', 'Sáng: 1 bát sữa chua không đường với hoa quả tươi và granola.'),
		exercise('', 'Reverse Snow Angels (Thiên thần ngược): 3 hiệp x 10-12 lần - Phát triển cơ lưng giữa.', 'Trưa: Cơm gạo lứt, thịt lợn luộc, canh rau mồng tơi.'),
		exercise('', 'Bicep Curls (Cuốn tạ): 3 hiệp x 12-15 lần - Phát triển cơ tay trước.', 'Chiều: Trái cây, 1 ít các loại hạt.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng trên.', 'Tối: Canh rau củ thập cẩm, đậu phụ hấp.'),

		exercise('Thứ 6: Cardio - Bụng (Cường độ trung bình)', 'Chạy bộ tại chỗ: 20 phút - Đốt mỡ thừa, tăng cường sức bền.', 'Sáng: Trứng chiên rau củ, ngũ cốc granola với sữa.'),
		exercise('', 'Mountain Climbers (Leo núi): 3 hiệp x 30 giây - Bài tập cardio, tăng nhịp tim.', 'Trưa: Cơm gạo lứt, cá kho tộ, rau luộc.'),
		exercise('', 'Crunches (Gập bụng): 3 hiệp x 15-20 lần - Phát triển cơ bụng trên.', 'Chiều: Bánh protein, sữa đậu nành.'),
		exercise('', 'Plank (Chống đẩy tĩnh): 3 hiệp, giữ tối đa 40 giây - Tăng cường sức mạnh cơ core.', 'Tối: Thịt bò bít tết, khoai tây nghiền, salad.'),

		exercise('Thứ 7: Toàn thân - Cường độ thấp', 'Jumping Jacks (Bật nhảy tại chỗ): 2 hiệp x 15 lần - Khởi động nhẹ nhàng.', 'Sáng: 1 bát cháo yến mạch với hoa quả tươi.'),
		exercise('', 'Push-ups (Hít đất): 2 hiệp, tối đa số lần có thể - Duy trì sức mạnh cơ ngực.', 'Trưa: Cơm gạo lứt, cá hấp, canh rau củ.'),
		exercise('', 'Squats (Gánh đùi): 2 hiệp x 12-15 lần - Duy trì sức mạnh cơ chân.', 'Chiều: Sinh tố hoa quả ít đường.'),
		exercise('', 'Plank (Chống đẩy tĩnh): 2 hiệp, giữ tối đa 20 giây - Duy trì sức mạnh cơ core.', 'Tối: Salad rau trộn với tôm/ ức gà.'),
		
		exercise('Chủ nhật', 'Nghỉ ngơi', '')
	].






% bang huong dan luyen tap
fitness_program_table(Program) -->
    html(table([class('fitness-program')],
        [caption('Kế hoạch luyện tập hàng tuần của bạn'),
         \fitness_program_header,
         \fitness_program_rows(Program)]
    )).

% Tieu de bang
fitness_program_header -->
    html(tr([th('Thứ'), th('Các bài tập'), th('Khẩu phần ăn')])).

% item
fitness_program_rows([]) --> [].
fitness_program_rows([exercise(Thứ , Workout, Meal) | Rest]) -->
    html(tr([td(Thứ ), td(Workout), td(Meal)])),
    fitness_program_rows(Rest).
	
gender(he) :- write('Nam').
gender(she) :- write('Nữ').

% Noi dung cua form HTML
form_content -->
    html(form([id('myForm'), action('/submit'), method('post')],
        [label([for('fullname')], 'Họ và tên'),
         input([type('text'), id('fullname'), name('fullname'), required, placeholder('Nhập họ và tên')]),
         br([]),
         label([for('age')], 'Tuổi'),
         input([type('number'), id('age'), name('age'), required, min(15), placeholder('Nhập tuổi')]),
         br([]),
         label([for('gender')], 'Giới tính'),
         select([name('gender'), id('gender')],
            [option([value('he')], 'Nam'),
             option([value('she')], 'Nữ')]),
         br([]),
         label([for('height')], 'Chiều cao (cm)'),
         input([type('number'), id('height'), name('height'), required, min(140), placeholder('Nhập chiều cao')]),
         br([]),
         label([for('weight')], 'Cân nặng (kg)'),
         input([type('number'), id('weight'), name('weight'), required,min(35), placeholder('Nhập cân nặng')]),
         br([]),
         label([for('goal')], 'Mục tiêu'),
         select([name('goal'), id('goal')],
            [option([value('tangcan')], 'Tăng cân'),
             option([value('giamcan')], 'Giảm cân')]),
         br([]),
         label([for('level')], 'Trình độ'),
         select([name('level'), id('level')],
            [option([value('nguoimoi')], 'Người mới tập dưới 3 tháng'),
             option([value('nguoicu')], 'Tập trên 3 tháng')]),
         br([]),
         label([for('type')], 'Chương trình tập'),
         select([name('type'), id('type')],
            [option([value('fullbody')], 'Toàn thân'),
             option([value('split')], 'Chia nhóm')]),
         br([]),
         label([for('facility')], 'Địa điểm tập'),
         select([name('facility'), id('facility')],
            [option([value('gym')], 'Tại phòng tập'),
             option([value('home')], 'Tại nhà')]),
         br([]),
         label([for('time')], 'Thời gian'),
         select([name('time'), id('time')],
			[option([value('bon')], '4 ngày/tuần - phù hợp cho người mới'),
			 option([value('nam')], '5 ngày/tuần - phù hợp cho người mới'),
             option([value('sau')], '6 ngày/tuần')]),
         br([]),
         input([type('submit'), value('Tạo bảng hướng dẫn tập gym GYM')])
        ]
    )).

% Khoi dong server
:- start_server.
