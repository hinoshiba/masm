環境準備
=====

* macOS 10.14.3
	* dosboxというエミュレータを利用

1. dosboxダウンロード
	* https://www.dosbox.com/download.php?main=1
2. masm assembler (8086.zip) 用意
3. 8086をdosboxがマウントしやすい位置に移動
	```bash
	mkdir -p ~/dosbox/
	cd ~/doxbox/
	cp ~/Downloads/8086.zip ./
	unzip 8086.zip
	rm 8086.zip
	```
4. 8086ディレクトリをマウント
	```dosbox
	mount c ~/dosbox/8086
	c:
	```
5. EDITを起動し、動作を確認

