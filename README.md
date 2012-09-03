# BNLoadingBar

Unobtrusive loading view for iOS.

(Supporting ARC/Non-ARC project.)

![](http://tobioka.net/wp-content/uploads/2012/09/bnloadingbar.png)

## How to use

* Copy `BNLoadingBar.h`, `BNLoadingBar.m` to your projects.
* Add `QuartzCore.framework` in Build Phases.
* Import `BNLoadingBar.h`.
* Call `[BNLoadingBar showForView:withMessage:]`.

## Example

    // Show
    [BNLoadingBar showForView:self.view withMessage:@"Loading..."];
    // Hide
    [BNLoadingBar hideForView:self.view];

## LICENSE

New BSD License

