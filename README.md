#CellFold

CellFold, UITableView+HCFoldTableView, is a category for UITableView which gives your UITableView some 3D feeling and perspective.

This project is totally inspired by [soulwire](https://github.com/soulwire)'s JavaScript project [FoldScroll](https://github.com/soulwire/FoldScroll).

##Usage

First, import QuartzCore in Build Phases

Second, import UITableView+HCFoldTableView.h in the controller where you're using a UITableView

Third, you need to implement `UIScrollViewDelegate -(void)scrollViewDidScroll:`

```
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Makes it work
    [self.tableView scrollViewDidScroll:scrollView];
}
```

![Preview](https://raw.github.com/hellozimi/CellFold/master/preview.jpg)

Cheers!