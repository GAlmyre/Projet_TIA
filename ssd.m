function result = ssd(p1, p2)
  result = sum(sum(sum((p1-p2).^2)));
end