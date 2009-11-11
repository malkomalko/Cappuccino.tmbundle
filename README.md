# TextMate bundle for Cappuccino development

To install with Git:

    mkdir -p ~/Library/Application\ Support/TextMate/Bundles
    cd ~/Library/Application\ Support/TextMate/Bundles
    git clone git://github.com/malkomalko/Cappuccino.tmbundle.git
    osascript -e 'tell app "TextMate" to reload bundles'

## Features

* Snippets for:
  * Core
    * Snippets for generating Classes/Categories/Importing/Accessors/Delegates/Selectors
  * Appkit (lots more coming)
    * (tf) CPTextField
  * Foundation (nothing here yet)
  * Resizing Masks
    * (mf) Resize Full Width/Height ![fullscreen](http://img.skitch.com/20091111-ngysen5mbf3rf5b6hrgnx7rqdd.preview.png)
    * (mc) Fixed Center ![fullscreen](http://img.skitch.com/20091111-k1t8n812m77g99acddb2cui6qb.preview.png)
    * (mtl) Fixed Top Left ![fullscreen](http://img.skitch.com/20091111-es8nfbj8uxkqkm2f2d5grd5dbj.preview.png)
    * (mtr) Fixed Top Right ![fullscreen](http://img.skitch.com/20091111-tupmuncegxijma7eu2f27xqd8k.preview.png)
    * (mbr) Fixed Bottom Right ![fullscreen](http://img.skitch.com/20091111-ne7u4rb9smgah7hxbd8ix2mw1e.preview.png)
    * (mbl) Fixed Bottom Left ![fullscreen](http://img.skitch.com/20091111-bk811p7n8wfp81adnwnpdgm5pk.preview.png)
    * (mhl) Resize Height Fixed Left ![fullscreen](http://img.skitch.com/20091111-xm29km85mp2t442864h51ppqef.preview.png)
    * (mhr) Resize Height Fixed Right ![fullscreen](http://img.skitch.com/20091111-7959c6us75g6ru44fm1ifywu8.preview.png)
    * (mwt) Resize Width Fixed Top ![fullscreen](http://img.skitch.com/20091111-me47cnyw61ck7bj3dpqcxakstn.preview.png)
    * (mwb) Resize Width Fixed Bottom ![fullscreen](http://img.skitch.com/20091111-njpxp63rn75f2gmdeyc9cj48qp.preview.png)
  * Patterns
    * Place for common code idioms and structures
  * Utilities
    * (gw) CGRectGetWidth
    * (gh) CGRectGetHeight
    * (ctrl + 0) CGRectMakeZero
    * (ctrl + r) CGRectMake
    * (asv) addSubView
    * (color) common CPColor methods
* Language/Syntax