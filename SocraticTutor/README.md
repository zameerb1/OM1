# Socratic Science Tutor

An AI-powered tutoring system that uses the Socratic method to help students discover knowledge through guided questioning rather than direct lecturing.

## Features

- **Socratic Method**: The AI asks questions to guide students to discover answers themselves, never lectures
- **Adaptive Questioning**: Adjusts difficulty based on student responses, confidence, and enthusiasm
- **Free-Form Answers**: No multiple choice - students explain concepts in their own words
- **Confidence Detection**: Identifies when students struggle and provides easier questions to build confidence
- **Session Summary**: Generates a comprehensive report showing strengths, areas to improve, and next steps
- **Secure API Key Handling**: API key stored only in memory during session, cleared when session ends

## Science Topics Available

- Solar System
- Human Body
- Ecosystems
- Matter & Chemistry
- Forces & Motion
- Electricity
- Weather & Climate
- Cells & Life

## Grade Levels Supported

5th through 10th grade, with age-appropriate expectations for each level.

## How It Works

1. **Setup**: Enter your Anthropic API key and student information
2. **Topic Selection**: Choose a science topic to explore
3. **Interactive Learning**: The tutor asks questions, you respond in your own words
4. **Adaptive Progression**: Questions adjust based on your understanding
5. **Session Summary**: Get a detailed report at the end

## Usage

1. Open `index.html` in a web browser
2. Enter your Anthropic API key (starts with `sk-ant-`)
3. Enter the student's name and grade level
4. Select a topic and start learning!

## API Key Security

- The API key is stored only in JavaScript memory during the session
- The key is automatically cleared when:
  - The session ends
  - The browser tab is closed
  - The user starts a new session

## Running Locally

Simply open `index.html` in a modern web browser. No server required.

For development with live reload:
```bash
# Using Python
python -m http.server 8000

# Using Node.js
npx serve .
```

## Technology

- Pure HTML, CSS, and JavaScript (no frameworks)
- Anthropic Claude API for AI responses
- Session-based storage for security
