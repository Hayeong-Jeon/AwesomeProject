<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>skidch</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 20px;
        }
        h2, h3 {
            margin-top: 20px;
        }
        hr {
            margin: 40px 0;
        }
        .center {
            display: flex;
            justify-content: center;
        }
        .image-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 20px 0;
        }
        .version-box {
            border: 1px solid #ccc;
            padding: 10px;
            margin: 20px 0;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: center;
        }
    </style>
</head>
<body>

<h1>skidch</h1>
<h3>스마트폰을 사용하는 어린이들의 눈 보호를 위한 어플리케이션</h3>
<div class="center">
    <img src="assets/images/logo.PNG" height="450" width="30%">
</div>

<h2>목차</h2>
<ul>
    <li><a href="#기능설명">1. 기능 설명</a>
        <ul>
            <li><a href="#비밀번호-설정">1.1 비밀번호 설정</a></li>
            <li><a href="#시력보호-모드">1.2 시력 보호 모드</a></li>
            <li><a href="#보행-시-사용-금지모드">1.3 보행 시 사용 금지 모드</a></li>
        </ul>
    </li>
    <li><a href="#기술-스택">2. 기술 스택</a></li>
    <li><a href="#version">3. 버전 정보</a></li>
    <li><a href="#team">4. 팀 정보 (Team Information)</a></li>
</ul>

<hr>
<h2 id="기능설명">기능 설명</h2>

<h3 id="비밀번호-설정">🤐비밀번호 설정🤐</h3>
<p>Storage.write 메서드를 사용하여 Flutter Secure Storage에 비밀번호를 저장합니다. StatefulWidget으로 구현하여 사용자의 입력 상태를 관리하고 GlobalKey<FormState>를 사용하여 폼의 상태를 추적하며 입력값의 유효성을 검사하도록 구현했습니다.</p>

<div class="image-container">
    <img src="assets/gif/password.gif" height="400" width="40%">
</div>

<hr>
<h3 id="시력보호-모드">🦉시력 보호 모드🌙</h3>
<p>안드로이드의 lightSensor를 활용하여 Flutter의 MethodChannel을 통해 애플리케이션과 네이티브 코드 간의 원활한 통신을 지원했습니다. ForegroundService와 BackgroundService를 이용하여 백그라운드에서도 동작이 가능하도록 설정하였습니다. 주변이 3초 이상 어두워지면 어두운 곳으로 이동한 것으로 판단해 화면이 잠기게 되며, 밝은 곳으로 이동할 시 잠금이 풀리는 로직을 구현했습니다.</p>

<div class="image-container">
    <img src="assets/gif/eye.gif" height="400" width="40%">
</div>

<hr>
<h3 id="보행-시-사용-금지모드">🚶‍♂️보행 시 사용 금지 모드🚶‍♀️</h3>
<p>안드로이드의 stepSensor를 활용하고, Flutter의 MethodChannel을 통해 애플리케이션과 네이티브 코드 간의 원활한 통신을 지원했습니다. ForegroundService와 BackgroundService를 이용하여 백그라운드에서도 동작이 가능하도록 설정하였습니다. 사용자가 걷기 시작하면 화면 오버레이가 뜨며, 화면을 방해하고, 2초 이상 걸음이 감지되지 않을 시 오버레이를 숨기는 로직을 구현했습니다.</p>

<div class="image-container">
    <img src="assets/gif/walk.gif" height="400" width="40%">
</div>

<hr>
<h2 id="기술-스택">기술 스택</h2>
<ul>
    <li><strong>Frontend</strong>: Flutter(Dart), HTML</li>
    <li><strong>Backend</strong>: Java, C++</li>
    <li><strong>Tools</strong>: CMake</li>
</ul>

<hr>
<h2 id="version">버전 정보</h2>
<div class="version-box">
    <p><strong>Android Studio</strong>: <code>2022.3.1.22 (Giraffe Patch 4)</code></p>
    <p><strong>Flutter SDK</strong>: <code>&gt;=3.1.5 &lt;4.0.0</code></p>
    <p><strong>Flutter Secure Storage</strong>: <code>^5.0.2</code></p>
    <p><strong>Java</strong>: <code>Java 8</code></p>
    <p><strong>Android Gradle Plugin</strong>: <code>7.4.2</code></p>
</div>

<hr>
<h2 id="team">프로젝트 실행 방법</h2>
<ol>
    <li>Install Android Studio</li>
    <li>Open Project</li>
    <li>Pair using Wi-Fi and QR scan</li>
    <li>Run the App</li>
</ol>

<hr>
<h1 id="team">👨‍👩‍👧‍👦 팀 정보 (Team Information)</h1>
<table>
    <tr>
        <th>팀원</th>
        <th>역할</th>
        <th>Email</th>
    </tr>
    <tr>
        <td>김보현</td>
        <td>Full Stack</td>
        <td>qhgus62@naver.com</td>
    </tr>
    <tr>
        <td>전하영</td>
        <td>Full Stack</td>
        <td>wjsgkdd@gmail.com</td>
    </tr>
    <tr>
        <td>조혜령</td>
        <td>FE</td>
        <td>sns220@naver.com</td>
    </tr>
</table>

</body>
</html>
