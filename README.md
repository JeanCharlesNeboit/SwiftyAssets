# SwiftyAssets

SwiftyAssets is an open source Command Line Tool used to generate iOS, WatchOS, macOS &amp; tvOS assets.

## Installation
### Clone the repository locally

**HTTPS**
```
git clone https://github.com/JeanCharlesNeboit/SwiftyAssets.git
```

**SSH**
```
git clone git@github.com:JeanCharlesNeboit/SwiftyAssets.git
```

### Generate the .xcodeproj
```
swift package generate-xcodeproj
```

## Get Started
### **Version & Help**
#### *Show the current version*
`SwiftyAssets --version`

```
SwiftyAssets v0.0.1
```

#### *Show the help*

`SwiftyAssets --help`

```
OVERVIEW: SwiftyAssets is an open source Command Line Tool used to generate iOS, WatchOS, macOS & tvOS assets.

USAGE: SwiftyAssets [--version] [--help] <command> <options>

OPTIONS:
  --version, -v   Display the current version of SwiftyAssets
  --help          Display available options

SUBCOMMANDS:
  colors          Generate Named Colors
  fonts           Generate Fonts
  images          Generate Images
  strings         Generate Localizable Strings
```

### **Generate Localizable Strings**
#### *Show the help*
`SwiftyAssets strings --help`

```
OVERVIEW: Generate Localizable Strings

OPTIONS:
  --copyright, -c      Copyright of the project
  --project-name, -n   Name of the project

POSITIONAL ARGUMENTS:
  input                Path of the strings CSV file
  output               Path of the folder where strings will be generated
```

#### *Example*
```
SwiftyAssets strings INPUT OUTPUT
```

### **Generate Colors**
#### *Show the help*
`SwiftyAssets colors --help`

```
OVERVIEW: Generate Named Colors

OPTIONS:
  --copyright, -c         Copyright of the project
  --input-file-type, -i   Use this option to specify the input file type
  --project-name, -n      Name of the project

POSITIONAL ARGUMENTS:
  input                   Path of the colors file
  output                  Path of the folder where colors will be generated
```

#### *Example*
```
SwiftyAssets colors **INPUT** **OUTPUT**
```

### Generate Fonts
`fonts` **INPUT** **OUTPUT**

### Generate Images
`images` **INPUT** **OUTPUT**

## SwiftyAssets Tests
### **Generate Colors**
`colors `
