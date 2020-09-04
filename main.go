package main

import (
	"log"
	"os"

	"github.com/go-qamel/qamel"
)

var view qamel.Viewer

// 检查错误
func checkErr(err error) {
	if err != nil {
		log.Panicln(err)
	}
}

func init() {
	RegisterQmlDanmu("BackEnd", 1, 0, "Danmu")
}

func main() {
	// 使用操作系统平台适应的图形库
	err := os.Setenv("QSG_RHI", "1")
	checkErr(err)
	//err := os.Setenv("QSG_INFO", "1")
	//checkErr(err)

	app := qamel.NewApplication(len(os.Args), os.Args)
	app.SetApplicationDisplayName("AcFun 弹幕姬")
	app.SetApplicationName("AcFun 弹幕姬")
	app.SetWindowIcon(":/res/acfunlogo.png")
	app.SetOrganizationDomain("https://github.com/orzogc/acfundmj")
	app.SetOrganizationName("AcFun")

	qamel.NewEngineWithSource("qrc:/res/main.qml")

	app.Exec()
}
