from flask import Flask, jsonify
import socket

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({
        "message": "ECS Pipeline running successfully!",
        "host": socket.gethostname()
    })

@app.route('/health')
def health():
    return jsonify({"status": "healthy"}), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
