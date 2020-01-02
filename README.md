masm
=================

## text book
* はじめて読むMASM
	* ISBN-13: 978-4871483131

---

* [setup](setup.md)
* [samplecode/1/OTENKI/OTENKI.ASM](samplecode/1/OTENKI/OTENKI.ASM)
* [samplecode/4-1/ESC/ESC.ASM](samplecode/4-1/ESC/ESC.ASM)
* [samplecode/4-2/ESC/ESC.ASM](samplecode/4-2/ESC/ESC.ASM)
* [samplecode/4-2/ESCF/ESCF.ASM](samplecode/4-2/ESCF/ESCF.ASM)

---

# しょうもないハマりポイント

* 4-1, ESC.ASM
	* dosboxだとsampleの通り実行するとeotがないから無限 JNE M_LOOPになる
	* ので、eot埋め込んだtextを用意する
* 4-2, ESC.ASM
	* 4-1と同じ話でこちらはlen0の読み込みになってくれない。eotをcheckするように変更 (ESCF.ASM)
