# Build remarks

The goal with this project is to add some fun remarks, while compiling the code.
Add this to your build pipeline to enjoy some commentary while the magic compiles.

## How to use

clone the repo somewhere, then add the script to your build tool. For the msbuild projects you can add them as in the examples. 
Just adjust the path with the correct directory where you cloned the repo. Don't use this for in production projects :D


| Parameter | Default    | Description                                                        |
| --------- | ---------- | ------------------------------------------------------------------ |
| Type      |            | You can set pre_build or post_build for a different set of remarks |
| Language  |            | if not defined a random language will be used                      |
| Remarks   | .\remarks\ | Absolute path to the remarks directory                             |

### From powershell
 
```
.\build_remarks.ps1 -Type pre_build -Language pl -Remarks c:\temp\remarks\
```

### Running as pre post build events

```xml
<Target Name="PreBuild" BeforeTargets="PreBuildEvent" Condition="'$(Configuration)' == 'Debug'">
  <Exec Command="powershell -ExecutionPolicy Unrestricted  -c &quot;&amp; { c:\temp\build_remarks.ps1 'pre_build' 'c:\temp\remarks\' 'it' }&quot;" />
</Target>
```

```xml
<Target Name="PostBuild" AfterTargets="PostBuildEvent" Condition="'$(Configuration)' == 'Debug'">
  <Exec Command="powershell -ExecutionPolicy Unrestricted  -c &quot;&amp; { c:\temp\build_remarks.ps1 'post_build' 'c:\temp\remarks\' 'pl' }&quot;" />
</Target>
```
