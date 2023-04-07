import React, { useState } from 'react';
import './QuizQuestion.css';

function QuizQuestion({ question, handleAnswer, index, numQuestions }) {
  const [selectedAnswer, setSelectedAnswer] = useState(null);

  const handleSelectAnswer = (answerId) => {
    setSelectedAnswer(answerId);
  };

  const handleSubmitAnswer = () => {
    handleAnswer(selectedAnswer);
    setSelectedAnswer(null);
  };

  const progress = ((index + 1) / numQuestions) * 100;

  return (
    <div>
      <div className="progress-bar">
        <div style={{ width: `${progress}%` }}></div>
      </div>
      <h2 className="question-text">{question.text}</h2>
      <ul className="choices">
        {question.choices.map((choice) => (
          <li
            key={choice.id}
            onClick={() => handleSelectAnswer(choice.id)}
            className={`choice ${selectedAnswer === choice.id ? 'selected' : ''}`}
          >
            {choice.text}
          </li>
        ))}
      </ul>
      <button className="button" disabled={!selectedAnswer} onClick={handleSubmitAnswer}>
        Submit Answer
      </button>
    </div>
  );
}

export default QuizQuestion;
