function ll --wraps=ls --description 'List contents of directory using long format in time sorted order, showing hidden directories'
	ls -lhAt $argv
end
