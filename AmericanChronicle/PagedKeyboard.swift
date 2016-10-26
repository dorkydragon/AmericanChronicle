final class PagedKeyboard: UIView {

    fileprivate let pages: [UIView]
    fileprivate let topBorder = UIImageView(image: UIImage.imageWithFillColor(UIColor.white))
    fileprivate let scrollView = UIScrollView()
    fileprivate let contentView = UIView()

    // mark: Init methods

    init(pages: [UIView]) {
        self.pages = pages
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 240))
        backgroundColor = UIColor.white

        addSubview(topBorder)
        topBorder.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(1.0/UIScreen.main.nativeScale)
        }

        scrollView.isScrollEnabled = false
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(topBorder.snp.bottom).offset(12.0)
            make.bottom.equalTo(-12.0)
            make.leading.equalTo(12.0)
            make.trailing.equalTo(-12.0)
        }

        scrollView.addSubview(contentView)
        var prevPage: UIView? = nil
        for page in pages {
            contentView.addSubview(page)
            page.snp.makeConstraints { make in
                make.width.equalTo(self.snp.width).offset(-24.0)
                make.top.equalTo(0)
                make.bottom.equalTo(0)
                if let prevPage = prevPage {
                    make.leading.equalTo(prevPage.snp.trailing)
                } else {
                    make.leading.equalTo(0)
                }
            }
            prevPage = page
        }
        prevPage?.snp.makeConstraints { make in
            make.trailing.equalTo(0)
        }

        contentView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(12.0)
            make.bottom.equalTo(self.snp.bottom).offset(-12.0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
    }

    override convenience init(frame: CGRect) {
        self.init(pages: [])
    }

    @available(*, unavailable)
    required convenience init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // mark: Internal methods

    func show(pageIndex: Int, animated: Bool) {
        let x = CGFloat(pageIndex) * (frame.size.width - 24)
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: animated)
    }

    func show(page: UIView, animated: Bool) {
        guard let pageIndex = pages.index(of: page) else { return }
        show(pageIndex: pageIndex, animated: animated)
    }

}
