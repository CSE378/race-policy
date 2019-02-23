function product = quatProduct(q, w)

firstCoord = q(1)*w(1) - q(2)*w(2) - q(3)*w(3) - q(4)*w(4);
secondCoord = w(1)*q(2) + w(2)*q(1) - w(3)*q(4) + w(4)*q(3);
thirdCoord = w(1)*q(3) + w(2)*q(4) + w(3)*q(1) - w(4)*q(2);
fourthCoord = w(1)*q(4) - w(2)*q(3) + w(3)*q(2) + w(4)*q(1);

product = [firstCoord, secondCoord, thirdCoord, fourthCoord];