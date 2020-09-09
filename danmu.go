package main

import (
	"context"
	"encoding/json"
	"log"
	"time"

	"github.com/go-qamel/qamel"
	"github.com/orzogc/acfundanmu"
)

var cancel context.CancelFunc

// Danmu 就是和qml的接口
type Danmu struct {
	qamel.QmlObject

	_ func(int)            `slot:"start"`
	_ func()               `slot:"stop"`
	_ func(string)         `signal:"newDanmu"`
	_ func(string, string) `signal:"newInfo"`
}

func (dm *Danmu) start(uid int) {
	go func() {
		var ctx context.Context
		ctx, cancel = context.WithCancel(context.Background())
		defer cancel()
		dq, err := acfundanmu.Start(ctx, uid, nil)
		if err != nil {
			log.Printf("获取弹幕出现错误：%v", err)
			dm.newDanmu("停止获取弹幕")
			return
		}

		go func() {
			for {
				select {
				case <-ctx.Done():
					return
				default:
					time.Sleep(5 * time.Second)
					info := dq.GetInfo()
					dm.newInfo(info.WatchingCount, info.LikeCount)
				}
			}
		}()

		for {
			if danmu := dq.GetDanmu(); danmu != nil {
				for _, d := range danmu {
					data, err := json.Marshal(d)
					checkErr(err)
					dm.newDanmu(string(data))
				}
			} else {
				dm.newDanmu("停止获取弹幕")
				break
			}
		}
	}()
}

func (dm *Danmu) stop() {
	cancel()
}
