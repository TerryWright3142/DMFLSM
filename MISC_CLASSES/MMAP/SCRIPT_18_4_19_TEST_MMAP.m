%SCRIPT_18_4_19_TEST_MMAP
disp('start');
mem_map = cMMap('test.dat');
mem_map.CreateMap();
mem_map.var1 = 1;
mem_map.var2 = 2;
mem_map.WriteMap();





clear