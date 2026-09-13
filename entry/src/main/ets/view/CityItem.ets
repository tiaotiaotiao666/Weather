@ComponentV2
export struct CityItem {
  @Require @Param name: string
  @Require @Param active: boolean
  @Event onTap: () => void = () => {}

  build() {
    Text(this.name)
      .fontSize(14)
      .fontColor(this.active ? '#4A90D9' : Color.White)
      .padding({ left: 14, right: 14, top: 6, bottom: 6 })
      .backgroundColor(this.active ? Color.White : '#66FFFFFF')
      .borderRadius(16)
      .onClick(() => {
        this.onTap()
      })
  }
}
