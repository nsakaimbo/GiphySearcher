#GiphySearcher

Tinkering wtih MVVM and the [Giphy API](https://github.com/Giphy/GiphyAPI#search-endpoint).

<p align="center">
<img src="/Documentation/screenshot.png"</img>
</p>

###Requirements
 * Xcode 7.3.1
 * iOS 9.3

###Pods: 
 * Moya/RxSwift, Alamofire, SwiftyJSON (Networking)
 * FLAnimatedImage, Nuke/FLAnimatedImageExtension (Caching and animated GIF support)
 * RxCocoa, RxSwift, NSObject+Rx (Functional Reactive)

###Installation
 * Clone this repo to your desktop
 * Open `GiphySearcher.xcworkspace`
 * Select an iPad device in the simulator. (For simplicity, the app is constrained to run on the iPad in portrait orientation)
 * Build and run! (The public Giphy API key is hard-coded into the app.)

 * Per the spec, all displayed GIFs animate and are filtered for family-friendliness. 😀 In addition, search results that have ever trended are highlighted in the bottom right with the following icon:

<p align="center">
<img src="/Documentation/trending_icon.jpg"</img>
</p>
 
##Miscellaneous Technical Highlights 

This was a fun little project. Major kudos to the Artsy team for open-sourcing [Eidolon/Kiosk](https://github.com/artsy/eidolon/tree/master/Kiosk), from which I learned a number of great design patterns (MVVM and otherwise).

 * [Moya](https://github.com/Moya/Moya) is an excellent way to set up the networking layer in an organized, logical manner. Furthermore, its [RxSwift extension](https://github.com/Moya/Moya/blob/master/docs/RxSwift.md) enables more seamless interaction with other functional reactive components.
 * It seems both [RxCocoa](https://github.com/ReactiveX/RxSwift/tree/master/RxCocoa) and [RxSwift](https://github.com/ReactiveX/RxSwift) are worth using in a complementary way. I haven't developed a preference for either, yet, though.
 * *Framerates and GIF caching*: Getting smooth framerates was one of the trickiest parts! I ended up up evaluating a couple different pods. Out-of-the-box, [FLAnimatedImage](https://github.com/Flipboard/FLAnimatedImage) was smooth, but at the cost of high RAM usage (even when used with SDWebImage for caching). [Kingfisher](https://github.com/onevcat/Kingfisher) has some nice cache customization options and seemed to manage memory much better, but was too jittery. I settled on [Nuke](https://github.com/kean/Nuke) and its FLAnimatedImage extension as a middle ground and am pretty happy with the result.
 
##Opportunities for Enhancement
 
 * Show larger version of GIF when selected. Currently, there is no interaction aside from search.
 * Enable API pagination (wasn't able to get around to this)

##Unit Testing
#...
<p align="center">
<img src="/Documentation/tumbleweed.gif"</img>
</p>

No tests yet! But I've tried to very deliberately expose dependencies (beyond being a natural side effect of MVVM). Also - one of the benefits of using Moya is how it treats testing as a first-class citizen by requiring you to stub your network requests. I used Paw, which is a handy little Mac utility that helps you create JSON files for stubbing endpoint responses. [The more I learn about testing](http://nsakaimbo.me/blog/2016/6/28/unit-testing-where-to-start-part-1), the more I believe in TDD. But for now, my tests will have to wait - leaving for [Belize](https://www.travelbelize.org) in a couple of hours!
