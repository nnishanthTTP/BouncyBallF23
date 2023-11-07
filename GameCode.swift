import Foundation

// As a friendly reminder, we can create bookmarks for our code, which are special comments to help us jump to sections of the code on the mini-map to the right
//MARK: Creating Shapes

// We'll create a ball Shape (as a circle) using the OvalShape initializer, which takes in a width and a height.
let ball = OvalShape(width: 40, height: 40)

// We'll create a barrier Shape (as a rectangle) using the PolygonShape Initializer, which takes in an array of points.
let barrierPoints = [
    Point(x: 0, y: 0),
    Point(x: 0, y: 25),
    Point(x: 300, y: 25),
    Point(x: 300, y: 0)
]
let barrier = PolygonShape(points: barrierPoints)

// We'll create the funnel (as a trapezoid), which we'll use to drop the ball from the top
let funnelPoints = [
    Point(x: 0, y: 50),
    Point(x: 80, y: 50),
    Point(x: 60, y: 0),
    Point(x: 20, y: 0)
]
let funnel = PolygonShape(points: funnelPoints)

// We'll create a target Shape (as a diamond), which we'll try to hit with our bouncy ball
let targetPoints = [
    Point(x: 10, y: 0),
    Point(x: 0, y: 10),
    Point(x: 10, y: 20),
    Point(x: 20, y: 10)
]
let target = PolygonShape(points: targetPoints)

//MARK: Setting up Shapes
// To make it easier for us to create each shape individually, we created separate functions to setup the ball, barrier(s), funnel, and target(s).
// After setting up any properties we added the shape to our scene.

fileprivate func setupBall() {
    ball.position = Point(x: 250, y: 400)
    ball.hasPhysics = true
    ball.fillColor = .red
    scene.add(ball)
}

fileprivate func setupBarrier() {
    barrier.position = Point(x: 200, y: 150)
    barrier.hasPhysics = true
    barrier.isImmobile = true
    scene.add(barrier)
}

fileprivate func setupFunnel() {
    funnel.position = Point(x: 200, y: scene.height - 25)
    funnel.onTapped = dropBall
    scene.add(funnel)
}

func setupTarget() {
    target.position = Point(x: 200, y: 400)
    target.hasPhysics = true
    target.isImmobile = true
    target.fillColor = .blue
    target.isImpermeable = false
    scene.add(target)
}

//MARK: Setup the Scene
// this setup function is being used to put shapes onto our screen. We'll call the functions up above so that we can do this.
func setup() {
    setupBall()
    setupBarrier()
    setupFunnel()
    setupTarget()
}

//MARK: Other Functions
// this function will set the ball's position to the funnel's, so that it looks like the ball is dropping out
func dropBall() {
    ball.position = funnel.position
}
