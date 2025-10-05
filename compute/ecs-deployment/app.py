from flask import Flask

# Create a Flask app
app = Flask(__name__)

@app.route("/")
def home():
    return "<h1>Hello, World!</h1><p>This is your simple Python web app 🚀</p>"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)

