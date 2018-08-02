cells = {'ctrl', 'ptx1nm', 'ptx10nm', 'ptx50nm', 'ptx100nm', 'ptx200nm', 'ptx1um', 'ptx5um'};
order=@(x)(strcmp(x, '00um'));
order(cells)