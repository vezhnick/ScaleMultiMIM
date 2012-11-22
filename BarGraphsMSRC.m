D_MIM = [12 83 70 81 93 84 91 55 97 87 92 82 69 51 61 59 66 53 44 9 58];
D_Ladi = [82 95 88 73 88 100 83 92 88 87 88 96 96 27 85 37 93 49 80 65 20];

names ={'building',
'grass',
'tree',
'cow',
'sheep',
'sky',
'airplane',
'water',
'face',
'car',
'bicycle',
'flower',
'sign',
'bird',
'book',
'chair',
'road',
'cat',
'dog',
'body',
'boat'};

d = [D_Ladi' D_MIM'];
barh(d);
set(gca, 'ytick', 1:21, 'yTicklabel', names')

legend('Associative Hierarchical CRF', 'MIM-STF-Obj');