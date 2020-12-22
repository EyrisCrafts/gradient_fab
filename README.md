# Gradient Floating Action Button 

GradientFab Widget is an expandable Floating Action Button that can expand into any number of child Fabs.  

## Gradient

You can use the **decoration** property to set gradient to the whole GradientFab. 

## Hide on Scroll

If the **scrollController** argument is set, GradientFab will hide on scroll. 

## Duration

The duration argument sets the animation duration. If not given, the animation duration defaults to 500 milliseconds



## Example

    ScrollController _controller;

    @override
    void initState() {
        _controller = ScrollController();
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Expandable FAB"),
            ),
            floatingActionButton: MyFloatingButton(
                controller: _controller,
                animationDuration: Duration(milliseconds: 200),
                children: [
                    AnimatedCustomIcon(
                        iconData: Icons.settings,
                        onPress: () {
                            log("Button pressed");
                        }),
                    AnimatedCustomIcon(
                        iconData: Icons.accessibility,
                        onPress: () {
                            log("Button pressed");
                        }),
                    AnimatedCustomIcon(
                        iconData: Icons.account_tree,
                        onPress: () {
                            log("Button pressed");
                        }),
                    AnimatedCustomIcon(
                        iconData: Icons.camera,
                        onPress: () {
                            log("Button pressed");
                        }),
                ],
            ),
            body: Container(
                width: double.infinity,
                child: ListView.builder(
                    controller: _controller,
                    itemBuilder: (context, index) => Container(
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey),
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                ))),
        );
    }


<p>
    <img src="https://github.com/K-Rafiki/gradient_fab/blob/master/screenshots/example.gif?raw=true"/>
</p>
