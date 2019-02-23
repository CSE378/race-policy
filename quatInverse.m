function inverse = quatInverse(q)
conj = [q(1), -q(2), -q(3), -q(4)];
inverse = conj / (norm(q)^2);