если which orca ничего не выдает
перейти в папку orca_5_0_4_linux_x86-64_shared_openmpi411

прописать чето такое:
export PATH=$PWD:$PATH
export LD_LIBRARY_PATH=$PWD:$LD_LIBRARY_PATH
export PATH=$PWD:$PATH
echo -e $PATH
which orca


В телеграмме Теория функционала плотности - 2024...
полезные ссылки по праку по орке, кем крафту, квантум еспрессо