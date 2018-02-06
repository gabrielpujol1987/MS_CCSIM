function ProcessBW(path)

	imagee = ReadImageOrCSV_Gabriel(path);
	image2 = BlackAndWhite_Gabriel(imagee);
	imwrite(image2, 'C:\PESQUISA\result.jpg');

end