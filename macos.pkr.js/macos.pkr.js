{
    "xcode": {
        "default": "12.2",
        "versions": [
            { "link": "12.3", "version": "12.3.0"},
            { "link": "12.2", "version": "12.2.0" },
            { "link": "12.1.1", "version": "12.1.1" },
            { "link": "12.1", "version": "12.1.0" },
            { "link": "12", "version": "12.0.1", "symlinks": ["12_beta"] },
            { "link": "11.7", "version": "11.7.0", "symlinks": ["11.7_beta"] },
            { "link": "11.6", "version": "11.6.0", "symlinks": ["11.6_beta"] },
            { "link": "11.5", "version": "11.5.0", "symlinks": ["11.5_beta"] },
            { "link": "11.4.1", "version": "11.4.1", "symlinks": ["11.4", "11.4.1_beta"] },
            { "link": "11.3.1", "version": "11.3.1", "symlinks": ["11.3", "11.3.1_beta"] },
            { "link": "11.2.1", "version": "11.2.1", "symlinks": ["11.2", "11.2.1_beta"] },
            { "link": "10.3", "version": "10.3", "symlinks": ["10.3_beta"] }
        ]
    },
    "xamarin": {
        "vsmac": "latest",
        "mono-versions": [
            "6.12.0.113", "6.10.0.106", "6.8.0.123", "6.6.0.166", "6.4.0.208"
        ],
        "ios-versions": [
            "14.6.0.15", "14.4.1.3", "14.2.0.12", "14.0.0.0", "13.20.2.2", "13.18.2.1", "13.16.0.13", "13.14.1.39", "13.10.0.21", "13.8.3.0", "13.6.0.12", "13.4.0.2", "13.2.0.47"
        ],
        "mac-versions": [
            "7.0.0.15", "6.22.1.26", "6.20.2.2", "6.18.3.2", "6.16.0.13", "6.14.1.39", "6.10.0.21", "6.8.3.0", "6.6.0.12", "6.4.0.2", "6.2.0.47"
        ],
        "android-versions": [
            "11.1.0.17", "11.0.2.0", "10.3.1.4", "10.2.0.100", "10.1.3.7", "10.0.6.2"
        ],
        "bundle-default": "6_12_4",
        "bundles": [
            {
                "symlink": "6_12_4",
                "mono":"6.12",
                "ios": "14.6",
                "mac": "7.0",
                "android": "11.1"
            },
            {
                "symlink": "6_12_3",
                "mono":"6.12",
                "ios": "14.4",
                "mac": "6.22",
                "android": "11.1"
            },
            {
                "symlink": "6_12_2",
                "mono":"6.12",
                "ios": "14.2",
                "mac": "6.20",
                "android": "11.0"
            },
            {
                "symlink": "6_12_1",
                "mono":"6.12",
                "ios": "14.0",
                "mac": "6.20",
                "android": "11.0"
            },
            {
                "symlink": "6_12_0",
                "mono":"6.12",
                "ios": "13.20",
                "mac": "6.20",
                "android": "11.0"
            },
            {
                "symlink": "6_10_0",
                "mono":"6.10",
                "ios": "13.18",
                "mac": "6.18",
                "android": "10.3"
            },
            {
                "symlink": "6_8_1",
                "mono":"6.8",
                "ios": "13.16",
                "mac": "6.16",
                "android": "10.2"
            },
            {
                "symlink": "6_8_0",
                "mono": "6.8",
                "ios": "13.14",
                "mac": "6.14",
                "android": "10.2"
            },
            {
                "symlink": "6_6_1",
                "mono": "6.6",
                "ios": "13.10",
                "mac": "6.10",
                "android": "10.1"
            },
            {
                "symlink": "6_6_0",
                "mono": "6.6",
                "ios": "13.8",
                "mac": "6.8",
                "android": "10.1"
            },
            {
                "symlink": "6_4_2",
                "mono": "6.4",
                "ios": "13.6",
                "mac": "6.6",
                "android": "10.0"
            },
            {
                "symlink": "6_4_1",
                "mono": "6.4",
                "ios": "13.4",
                "mac": "6.4",
                "android": "10.0"
            },
            {
                "symlink": "6_4_0",
                "mono": "6.4",
                "ios": "13.2",
                "mac": "6.2",
                "android": "10.0"
            }
        ]
    },
    "java": {
        "default": "8",
        "versions": [
            "7", "8", "11", "12", "13", "14"
        ]
    },
    "android": {
        "platform_min_version": "24",
        "build_tools_min_version": "24.0.0",
        "extra-list": [
            "android;m2repository", "google;m2repository", "google;google_play_services", "intel;Hardware_Accelerated_Execution_Manager", "m2repository;com;android;support;constraint;constraint-layout-solver;1.0.0-beta1", "m2repository;com;android;support;constraint;constraint-layout-solver;1.0.0-beta2", "m2repository;com;android;support;constraint;constraint-layout-solver;1.0.0-beta3", "m2repository;com;android;support;constraint;constraint-layout-solver;1.0.0-beta4", "m2repository;com;android;support;constraint;constraint-layout-solver;1.0.0-beta5", "m2repository;com;android;support;constraint;constraint-layout-solver;1.0.0", "m2repository;com;android;support;constraint;constraint-layout-solver;1.0.1", "m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2", "m2repository;com;android;support;constraint;constraint-layout;1.0.0-beta1", "m2repository;com;android;support;constraint;constraint-layout;1.0.0-beta2", "m2repository;com;android;support;constraint;constraint-layout;1.0.0-beta3", "m2repository;com;android;support;constraint;constraint-layout;1.0.0-beta4", "m2repository;com;android;support;constraint;constraint-layout;1.0.0-beta5", "m2repository;com;android;support;constraint;constraint-layout;1.0.0", "m2repository;com;android;support;constraint;constraint-layout;1.0.1", "m2repository;com;android;support;constraint;constraint-layout;1.0.2"
        ],
        "addon-list": [
            "addon-google_apis-google-24", "addon-google_apis-google-23", "addon-google_apis-google-22", "addon-google_apis-google-21"
        ]
    },
    "powershellModules": [
        {
            "name": "Az",
            "versions": [
                "4.8.0"
            ]
        },
        {"name": "MarkdownPS"},
        {"name": "Pester"}
    ],
    "toolcache": [
        {
            "name": "Python",
            "url" : "https://raw.githubusercontent.com/actions/python-versions/main/versions-manifest.json",
            "arch": "x64",
            "platform" : "darwin",
            "versions": [
                "2.7.*",
                "3.5.*",
                "3.6.*",
                "3.7.*",
                "3.8.*",
                "3.9.*"
            ]
        },
        {
            "name": "PyPy",
            "arch": "x64",
            "platform" : "darwin",
            "versions": [
                "2.7",
                "3.6"
            ]
        },
        {
            "name": "Node",
            "url" : "https://raw.githubusercontent.com/actions/node-versions/main/versions-manifest.json",
            "platform" : "darwin",
            "arch": "x64",
            "versions": [
                "8.*",
                "10.*",
                "12.*",
                "14.*"
            ]
        },
        {
            "name": "Go",
            "url" : "https://raw.githubusercontent.com/actions/go-versions/main/versions-manifest.json",
            "arch": "x64",
            "platform" : "darwin",
            "versions": [
                "1.13.*",
                "1.14.*",
                "1.15.*"
            ]
        },
        {
            "name": "Ruby",
            "arch": "x64",
            "versions": [
                "2.4.*",
                "2.5.*",
                "2.6.*",
                "2.7.*"
            ]
        }
    ],
    "pipx": [
        {
            "package": "yamllint",
            "cmd": "yamllint --version"
        }
    ],
    "dotnet": {
        "versions": [
            "2.1",
            "3.0",
            "3.1",
            "5.0"
        ]
    }
}