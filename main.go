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
	app := qamel.NewApplication(len(os.Args), os.Args)
	app.SetApplicationDisplayName("AcFun 弹幕姬")
	app.SetApplicationName("AcFun 弹幕姬")
	app.SetWindowIcon(":/res/acfunlogo.ico")
	app.SetOrganizationDomain("https://github.com/orzogc")
	app.SetOrganizationName("AcFun")

	qamel.NewEngineWithSource("qrc:/res/main.qml")

	app.Exec()
}
