import React, { useEffect, useState } from "react";
import Confetti from "react-confetti";
import './ConfettiAnimation.css';

const ConfettiAnimation = ({ show, onAnimationEnd }) => {
  const [confettiAnimation, setConfettiAnimation] = useState({});

  useEffect(() => {
    if (show) {
      setConfettiAnimation({});
      setTimeout(() => {
        setConfettiAnimation({ fadeOut: true });
        setTimeout(() => {
          setConfettiAnimation('');
          onAnimationEnd(); // Call the onAnimationEnd callback when the animation is done
        }, 1000);
      }, 5000);
    }
  }, [show, onAnimationEnd]);

  return (
    <div className={`confettiContainer${confettiAnimation.fadeOut ? ' fadeOut' : ''}`}>
      <Confetti
        width={window.innerWidth}
        height={window.innerHeight}
        numberOfPieces={500}
      />
    </div>
  );
};

export default ConfettiAnimation;