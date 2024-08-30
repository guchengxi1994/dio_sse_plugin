from flask import Flask, Response
import time

app = Flask(__name__)

def event_stream():
    while True:
        # 生成服务器端事件，每隔一秒发送一次
        time.sleep(1)
        yield "我是谁？？？？？？？"*10000 + f"data: The current time is {time.strftime('%Y-%m-%d %H:%M:%S')}\n\n"  

@app.route('/sse')
def sse():
    # 设置响应头，确保这是一个流响应
    return Response(event_stream(), content_type='text/event-stream')

if __name__ == '__main__':
    app.run(debug=True, threaded=True)