import ProjectDescription

let project = Project(
    name: "Ignite",
    targets: [
        .target(
            name: "Ignite",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.ignite",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"]
        ),
    ]
)