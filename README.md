# Build remarks

The goal with this project is to add some fun remarks, while compiling the code.
Add this to your build pipeline to enjoy some commentary while the magic compiles.

## How to use

Post build event


| Parameter | Default    | Description                                                        |
| --------- | ---------- | ------------------------------------------------------------------ |
| Type      |            | You can set pre_build or post_build for a different set of remarks |
| Language  |            | if not defined a random language will be used                      |
| Remarks   | .\remarks\ | Absolute path to the remarks directory                             |

### From powershell
 
```
.\build_remarks.ps1 -Type pre_build -Language pl -Remarks c:\temp\build\remarks\
```

### Running as pre post build events

```xml
<Target Name="PreBuild" BeforeTargets="PreBuildEvent">
  <Exec Command="powershell -ExecutionPolicy Unrestricted  -c &quot;&amp; { c:\temp\build_remarks.ps1 'pre_build' 'c:\temp\remarks\' 'en' }&quot;" />
</Target>
```

```xml
<Target Name="PostBuild" AfterTargets="PostBuildEvent">
  <Exec Command="powershell -ExecutionPolicy Unrestricted  -c &quot;&amp; { c:\temp\build_remarks.ps1 'post_build' 'c:\temp\remarks\' 'en' }&quot;" />
</Target>
```
