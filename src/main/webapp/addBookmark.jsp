<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>북마크 추가</title>
    <style>
        body { font-family: Arial, sans-serif; }
        .form-container {
            width: 300px;
            margin: 0 auto;
            padding-top: 50px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
        }
        input[type="text"] {
            width: 100%;
            padding: 8px;
            font-size: 14px;
            border-radius: 4px;
            border: 1px solid #ddd;
        }

        .btn {
            margin-bottom: 20px;
            padding: 8px 16px;
            cursor: pointer;
        }
    </style>
</head>
<body>

<h2>북마크 추가</h2>

<div class="form-container">
    <form action="addBookmarkAction.jsp" method="post" accept-charset="UTF-8">
        <div class="form-group">
            <label for="name">북마크 이름</label>
            <input type="text" id="name" name="name" required>
        </div>
        <div class="form-group">
            <label for="order">순서</label>
            <input type="text" id="order" name="order" required>
        </div>
        <a href="bookmark.jsp" class="btn">돌아가기</a>
        <button type="submit" class="btn">저장</button>
    </form>
</div>

</body>
</html>