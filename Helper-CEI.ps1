param(
    [string]$BatPath,
    [string]$Flag
)

$ErrorActionPreference = 'Stop'

if (-not $Flag) {
    $entry = if ($BatPath) { $BatPath } else { Join-Path $PSScriptRoot 'ComfyUI-Easy-Install.bat' }
    if (Test-Path -LiteralPath $entry) {
        Start-Process -FilePath $entry -WorkingDirectory (Split-Path -Parent $entry)
    }
    exit 0
}

function Write-FailFlag {
    if ($Flag) { try { [IO.File]::WriteAllText("$Flag.fail", 'fail') } catch { } }
}

try {
    Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Xaml
} catch {
    Write-FailFlag
    exit 1
}

if (-not $BatPath) { $BatPath = Join-Path $PSScriptRoot 'ComfyUI-Easy-Install.bat' }
$BatPath    = [IO.Path]::GetFullPath($BatPath)
$BaseDir    = Split-Path -Parent $BatPath
$LogPath    = Join-Path $BaseDir 'ComfyUI-Easy-Install.log'
$InstallDir = Join-Path $BaseDir 'ComfyUI-Easy-Install'
$LauncherLnk = Join-Path $InstallDir 'ComfyUI-EZi Launcher.lnk'
$EscRegex   = "$([char]27)\[[0-9;?]*[A-Za-z]"

$AppTitle   = 'ComfyUI-Easy-Install'
$Version    = ''
$StageNames = @('Preparing', 'Python packages', 'Custom nodes', 'Finishing')
$NodeStage  = 3
$StageTotal = @{}

$batLines = [IO.File]::ReadAllLines($BatPath)
foreach ($l in $batLines) {
    $t = $l.Trim()
    if ($t -match '^set "CEI_Title=(.+)"$' -and $Matches[1] -match 'v(\d+(\.\d+)+)') { $Version = 'v' + $Matches[1] }
    elseif ($t -match '^set "CEI_STAGES=(.+)"$') { $StageNames = $Matches[1].Split('|') }
    elseif ($t -match '^set "CEI_NODE_STAGE=(\d+)"$') { $NodeStage = [int]$Matches[1] }
}
foreach ($l in $batLines) {
    $t = $l.Trim()
    $k = 0
    if ($t -match '^(?i)call\s+:step\s+(\d+)\s') { $k = [int]$Matches[1] }
    elseif ($t -match '^(?i)call\s+:get_node\s') { $k = $NodeStage }
    if ($k -gt 0) {
        if ($StageTotal.ContainsKey($k)) { $StageTotal[$k]++ } else { $StageTotal[$k] = 1 }
    }
}
$GrandTotal = 0
foreach ($v in $StageTotal.Values) { $GrandTotal += $v }

$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="ComfyUI-Easy-Install" Width="640" SizeToContent="Height"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent"
        ResizeMode="CanMinimize" WindowStartupLocation="CenterScreen"
        FontFamily="Segoe UI" FontSize="13" Foreground="#EDF3FF"
        UseLayoutRounding="True" TextOptions.TextFormattingMode="Display">
  <Window.TaskbarItemInfo>
    <TaskbarItemInfo/>
  </Window.TaskbarItemInfo>
  <Window.Resources>
    <Style TargetType="ProgressBar">
      <Setter Property="Height" Value="8"/>
      <Setter Property="Minimum" Value="0"/>
      <Setter Property="Maximum" Value="100"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="ProgressBar">
            <Grid>
              <Border x:Name="PART_Track" CornerRadius="5" Background="#22374B"/>
              <Border x:Name="PART_Indicator" CornerRadius="5" HorizontalAlignment="Left" Background="{TemplateBinding Foreground}"/>
            </Grid>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="Btn" TargetType="Button">
      <Setter Property="Foreground" Value="#EDF3FF"/>
      <Setter Property="Background" Value="#22374B"/>
      <Setter Property="BorderBrush" Value="#304659"/>
      <Setter Property="Padding" Value="18,7"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Grid>
              <Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="1" CornerRadius="7"/>
              <Border x:Name="Hover" Background="White" Opacity="0" CornerRadius="7"/>
              <ContentPresenter Margin="{TemplateBinding Padding}" HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Grid>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="Hover" Property="Opacity" Value="0.07"/>
              </Trigger>
              <Trigger Property="IsPressed" Value="True">
                <Setter TargetName="Hover" Property="Opacity" Value="0.14"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="BtnPrimary" TargetType="Button" BasedOn="{StaticResource Btn}">
      <Setter Property="Background" Value="#82DFCD"/>
      <Setter Property="BorderBrush" Value="#82DFCD"/>
      <Setter Property="Foreground" Value="#09232D"/>
      <Setter Property="FontWeight" Value="SemiBold"/>
    </Style>
    <Style x:Key="ChromeBtn" TargetType="Button">
      <Setter Property="Width" Value="38"/>
      <Setter Property="Height" Value="30"/>
      <Setter Property="Foreground" Value="#A1B3CC"/>
      <Setter Property="FontFamily" Value="Segoe MDL2 Assets"/>
      <Setter Property="FontSize" Value="10"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Grid Background="Transparent">
              <Border x:Name="Hover" Background="White" Opacity="0" CornerRadius="6"/>
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Grid>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="Hover" Property="Opacity" Value="0.08"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="BtnDanger" TargetType="Button" BasedOn="{StaticResource Btn}">
      <Setter Property="Background" Value="#E5534B"/>
      <Setter Property="BorderBrush" Value="#E5534B"/>
      <Setter Property="Foreground" Value="White"/>
    </Style>
    <Style x:Key="Check" TargetType="CheckBox">
      <Setter Property="Foreground" Value="#EDF3FF"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="CheckBox">
            <StackPanel Orientation="Horizontal" Background="Transparent">
              <Border x:Name="Box" Width="18" Height="18" CornerRadius="5" BorderThickness="1.5" BorderBrush="#49758A" Background="Transparent" VerticalAlignment="Center">
                <TextBlock x:Name="Mark" Text="&#xE73E;" FontFamily="Segoe MDL2 Assets" FontSize="11" Foreground="#09232D"
                           HorizontalAlignment="Center" VerticalAlignment="Center" Visibility="Collapsed"/>
              </Border>
              <ContentPresenter Margin="10,0,0,0" VerticalAlignment="Center"/>
            </StackPanel>
            <ControlTemplate.Triggers>
              <Trigger Property="IsChecked" Value="True">
                <Setter TargetName="Box" Property="Background" Value="#82DFCD"/>
                <Setter TargetName="Box" Property="BorderBrush" Value="#82DFCD"/>
                <Setter TargetName="Mark" Property="Visibility" Value="Visible"/>
              </Trigger>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="Box" Property="BorderBrush" Value="#7B9BB6"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
  </Window.Resources>

  <Border Margin="14" CornerRadius="12" Background="#0B1926" BorderBrush="#304659" BorderThickness="1">
    <Border.Effect>
      <DropShadowEffect BlurRadius="20" ShadowDepth="0" Opacity="0.55"/>
    </Border.Effect>
    <Grid>
    <StackPanel>
      <Grid x:Name="Header" Background="Transparent" Margin="22,16,10,0">
        <Grid.ColumnDefinitions>
          <ColumnDefinition Width="Auto"/>
          <ColumnDefinition Width="*"/>
          <ColumnDefinition Width="Auto"/>
        </Grid.ColumnDefinitions>
        <Viewbox x:Name="LogoBox" Width="44" Height="34" VerticalAlignment="Center"/>
        <StackPanel Grid.Column="1" Margin="14,0,0,0" VerticalAlignment="Center">
          <TextBlock x:Name="TitleText" Text="ComfyUI-Easy-Install" FontSize="17" FontWeight="SemiBold" Foreground="White"/>
          <TextBlock x:Name="SubText" Foreground="#7B9BB6" FontSize="12"/>
        </StackPanel>
        <StackPanel Grid.Column="2" Orientation="Horizontal" VerticalAlignment="Top">
          <Button x:Name="MinBtn" Style="{StaticResource ChromeBtn}" Content="&#xE921;"/>
          <Button x:Name="CloseBtn" Style="{StaticResource ChromeBtn}" Content="&#xE8BB;"/>
        </StackPanel>
      </Grid>

      <StackPanel Margin="26,22,26,22">
        <Grid>
          <TextBlock x:Name="StageText" Text="Checking the system..." FontWeight="SemiBold" Foreground="#EDF3FF"/>
          <TextBlock x:Name="StageCount" HorizontalAlignment="Right" Foreground="#EDF3FF" FontWeight="SemiBold"/>
        </Grid>
        <ProgressBar x:Name="StageBar" Margin="0,9,0,0" Foreground="#82DFCD"/>

        <Grid Margin="0,12,0,0">
          <TextBlock x:Name="CurrentText" Foreground="#A1B3CC" TextTrimming="CharacterEllipsis" Margin="0,0,60,0"/>
          <TextBlock x:Name="StepTime" HorizontalAlignment="Right" Foreground="#65768B"/>
        </Grid>
        <Grid x:Name="ActivityTrack" Height="3" Margin="0,7,0,0" ClipToBounds="True" Background="#203649">
          <Border x:Name="DlFill" HorizontalAlignment="Left" Width="0" Background="#82DFCD"/>
          <Border x:Name="Shimmer" Width="110" HorizontalAlignment="Left">
            <Border.Background>
              <LinearGradientBrush StartPoint="0,0" EndPoint="1,0">
                <GradientStop Color="#0082DFCD" Offset="0"/>
                <GradientStop Color="#FF82DFCD" Offset="0.5"/>
                <GradientStop Color="#0082DFCD" Offset="1"/>
              </LinearGradientBrush>
            </Border.Background>
            <Border.RenderTransform>
              <TranslateTransform x:Name="ActX" X="-110"/>
            </Border.RenderTransform>
          </Border>
        </Grid>
        <Grid Margin="0,6,0,0">
          <TextBlock x:Name="DlText" Foreground="#7B9BB6" FontSize="12" Text=" "/>
          <TextBlock x:Name="SpeedText" HorizontalAlignment="Right" Foreground="#7B9BB6" FontSize="12"/>
        </Grid>

        <Grid Margin="0,20,0,0">
          <TextBlock Text="Overall progress" FontWeight="SemiBold" Foreground="#EDF3FF"/>
          <TextBlock x:Name="TotalCount" HorizontalAlignment="Right" FontWeight="SemiBold" Foreground="White"/>
        </Grid>
        <ProgressBar x:Name="TotalBar" Margin="0,9,0,0" Height="14">
          <ProgressBar.Foreground>
            <LinearGradientBrush StartPoint="0,0" EndPoint="1,0">
              <GradientStop Color="#70D2C3" Offset="0"/>
              <GradientStop Color="#94E4D3" Offset="1"/>
            </LinearGradientBrush>
          </ProgressBar.Foreground>
        </ProgressBar>

        <Grid Margin="0,14,0,0">
          <TextBlock x:Name="ElapsedText" Foreground="#7B9BB6"/>
          <StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
            <StackPanel x:Name="WarnBadge" Orientation="Horizontal" Visibility="Collapsed">
              <Ellipse Width="8" Height="8" Fill="#F2B544" VerticalAlignment="Center"/>
              <TextBlock x:Name="WarnText" Margin="6,0,0,0" Foreground="#F2B544"/>
            </StackPanel>
            <StackPanel x:Name="ErrBadge" Orientation="Horizontal" Visibility="Collapsed" Margin="16,0,0,0">
              <Ellipse Width="8" Height="8" Fill="#F0525B" VerticalAlignment="Center"/>
              <TextBlock x:Name="ErrText" Margin="6,0,0,0" Foreground="#F0525B"/>
            </StackPanel>
          </StackPanel>
        </Grid>

        <Border x:Name="ProblemsBox" Visibility="Collapsed" Margin="0,14,0,0" Padding="12,8" CornerRadius="8" Background="#102638" BorderBrush="#304659" BorderThickness="1">
          <ScrollViewer x:Name="ProblemsScroll" MaxHeight="110" VerticalScrollBarVisibility="Auto">
            <StackPanel x:Name="ProblemsList"/>
          </ScrollViewer>
        </Border>

        <Border x:Name="ResultBox" Visibility="Collapsed" Margin="0,14,0,0" Padding="14,12" CornerRadius="8" Background="#102638">
          <StackPanel>
            <Grid>
              <Grid.ColumnDefinitions>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="*"/>
              </Grid.ColumnDefinitions>
              <Border x:Name="ResultIcon" Width="36" Height="36" CornerRadius="18" VerticalAlignment="Top" Margin="0,0,14,0">
                <TextBlock x:Name="ResultGlyph" FontFamily="Segoe MDL2 Assets" FontSize="16" FontWeight="Bold"
                           HorizontalAlignment="Center" VerticalAlignment="Center"/>
              </Border>
              <StackPanel Grid.Column="1" VerticalAlignment="Center">
                <TextBlock x:Name="ResultText" TextWrapping="Wrap" FontWeight="SemiBold" FontSize="15"/>
                <TextBlock x:Name="HintText" TextWrapping="Wrap" Foreground="#A1B3CC" Margin="0,5,0,0" LineHeight="19" Visibility="Collapsed"/>
              </StackPanel>
            </Grid>
            <TextBox x:Name="LogTail" Visibility="Collapsed" Margin="0,10,0,0" IsReadOnly="True" BorderThickness="0"
                     Background="#09232D" Foreground="#A1B3CC" Padding="10,8" MaxHeight="190"
                     FontFamily="Cascadia Mono, Consolas" FontSize="11.5"
                     TextWrapping="NoWrap" VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Auto"/>
          </StackPanel>
        </Border>

        <Grid Margin="0,20,0,0">
          <StackPanel Orientation="Horizontal" HorizontalAlignment="Left">
            <Button x:Name="LogBtn" Style="{StaticResource Btn}" Content="Show log"/>
            <Button x:Name="CopyBtn" Style="{StaticResource Btn}" Content="Copy details" Margin="10,0,0,0" Visibility="Collapsed"/>
          </StackPanel>
          <StackPanel Orientation="Horizontal" HorizontalAlignment="Right">
            <Button x:Name="FolderBtn" Style="{StaticResource Btn}" Content="Open folder" Visibility="Collapsed" Margin="0,0,10,0"/>
            <Button x:Name="LaunchBtn" Style="{StaticResource BtnPrimary}" Content="Start ComfyUI" Visibility="Collapsed" Margin="0,0,10,0"/>
            <Button x:Name="ActionBtn" Style="{StaticResource Btn}" Content="Cancel"/>
          </StackPanel>
        </Grid>
      </StackPanel>
    </StackPanel>

    <Border x:Name="Overlay" Visibility="Collapsed" CornerRadius="12" Background="#C7050C14">
      <Border x:Name="Card" Width="430" VerticalAlignment="Center" HorizontalAlignment="Center" Padding="24,22,24,20"
              CornerRadius="12" Background="#122438" BorderBrush="#3B566F" BorderThickness="1" RenderTransformOrigin="0.5,0.5">
        <Border.RenderTransform>
          <ScaleTransform x:Name="CardScale" ScaleX="1" ScaleY="1"/>
        </Border.RenderTransform>
        <Border.Effect>
          <DropShadowEffect BlurRadius="24" ShadowDepth="0" Opacity="0.6"/>
        </Border.Effect>
        <StackPanel>
          <StackPanel Orientation="Horizontal">
            <Border Width="38" Height="38" CornerRadius="19" Background="#33291A">
              <TextBlock Text="&#xE7BA;" FontFamily="Segoe MDL2 Assets" FontSize="17" Foreground="#F2B544"
                         HorizontalAlignment="Center" VerticalAlignment="Center" Margin="0,0,0,2"/>
            </Border>
            <TextBlock Text="Stop the installation?" FontSize="16" FontWeight="SemiBold" Foreground="White"
                       VerticalAlignment="Center" Margin="14,0,0,0"/>
          </StackPanel>
          <TextBlock x:Name="DlgBody" TextWrapping="Wrap" Foreground="#A1B3CC" Margin="52,8,0,0" LineHeight="19"
                     Text="ComfyUI will not be usable. To install it later, the unfinished folder has to be removed first."/>
          <CheckBox x:Name="DelCheck" Style="{StaticResource Check}" IsChecked="True" Margin="52,16,0,0"
                    Content="Delete the unfinished 'ComfyUI-Easy-Install' folder"/>
          <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,22,0,0">
            <Button x:Name="DlgKeep" Style="{StaticResource Btn}" Content="Continue installing" Margin="0,0,10,0"/>
            <Button x:Name="DlgStop" Style="{StaticResource BtnDanger}" Content="Stop"/>
          </StackPanel>
        </StackPanel>
      </Border>
    </Border>
    </Grid>
  </Border>
</Window>
'@

try {
    $win = [Windows.Markup.XamlReader]::Parse($xaml)
} catch {
    Write-FailFlag
    exit 1
}

$ui = @{}
foreach ($n in 'Header','LogoBox','TitleText','SubText','MinBtn','CloseBtn','StageText','StageCount','StageBar',
               'CurrentText','StepTime','ActivityTrack','ActX','DlFill','Shimmer','DlText','SpeedText','TotalCount','TotalBar','ElapsedText','WarnText',
               'ErrText','WarnBadge','ErrBadge','HintText','CopyBtn','ResultIcon','ResultGlyph','LaunchBtn','ProblemsBox','ProblemsScroll','ProblemsList','ResultBox','ResultText','LogTail',
               'LogBtn','FolderBtn','ActionBtn','Overlay','Card','CardScale','DlgBody','DelCheck','DlgKeep','DlgStop') {
    $ui[$n] = $win.FindName($n)
}

function New-Logo {
    $shapes = @(
        'F1 M48.21 45c0,1.71 0.68,3.34 1.89,4.55 1.21,1.21 2.84,1.88 4.54,1.88l6.43 0c1.71,-0 3.34,-0.68 4.55,-1.89 1.21,-1.21 1.88,-2.84 1.88,-4.54l0 -38.57c-0,-1.71 -0.68,-3.34 -1.89,-4.55 -1.21,-1.21 -2.84,-1.88 -4.54,-1.88l-6.43 0c-1.71,0 -3.34,0.68 -4.55,1.89 -1.21,1.21 -1.88,2.84 -1.88,4.54l0 38.57zm53.1 45l-86.91 0c-3.82,0 -7.48,-1.51 -10.18,-4.21 -2.7,-2.7 -4.22,-6.38 -4.22,-10.19l0 -48.34c-0,-3.82 1.51,-7.48 4.21,-10.18 2.7,-2.7 6.37,-4.22 10.19,-4.22l24.17 0 0 19.28 -19.28 0 0 38.57 77.14 0 0 -38.57 -18.81 0 0 -19.28 23.7 0c3.82,-0 7.48,1.51 10.18,4.21 2.7,2.7 4.22,6.38 4.22,10.19l0 48.34c0,3.82 -1.51,7.48 -4.21,10.18 -2.7,2.7 -6.37,4.22 -10.19,4.22z'
    )
    $c = New-Object System.Windows.Controls.Canvas
    $c.Width = 115.71
    $c.Height = 90
    $green = [Windows.Media.BrushConverter]::new().ConvertFrom('#43A25A')
    foreach ($d in $shapes) {
        $path = New-Object System.Windows.Shapes.Path
        $path.Data = [Windows.Media.Geometry]::Parse($d)
        $path.Fill = $green
        [void]$c.Children.Add($path)
    }
    return $c
}

function New-LogoIcon {
    $vb = New-Object System.Windows.Controls.Viewbox
    $vb.Child = New-Logo
    $vb.Width = 64
    $vb.Height = 64
    $vb.Measure([Windows.Size]::new(64, 64))
    $vb.Arrange([Windows.Rect]::new(0, 0, 64, 64))
    $vb.UpdateLayout()
    $rtb = New-Object System.Windows.Media.Imaging.RenderTargetBitmap(64, 64, 96, 96, [Windows.Media.PixelFormats]::Pbgra32)
    $rtb.Render($vb)
    $rtb.Freeze()
    return $rtb
}

$ui.LogoBox.Child = New-Logo
try { $win.Icon = New-LogoIcon } catch { }
$win.Title = $AppTitle
$ui.SubText.Text = (@($Version, 'Pixaroma Community Edition') | Where-Object { $_ }) -join '  -  '
$ui.TotalCount.Text = "0 / $GrandTotal"
$tb = $win.TaskbarItemInfo
$brush = [Windows.Media.BrushConverter]::new()

$S = @{
    Proc      = $null
    Pos       = [long]0
    Pending   = ''
    Decoder   = [Text.Encoding]::UTF8.GetDecoder()
    Stage     = 0
    StageIdx  = 0
    Index     = 0
    Total     = $GrandTotal
    Errors    = 0
    Warnings  = 0
    Done      = $false
    Finished  = $false
    Tail      = New-Object 'System.Collections.Generic.Queue[string]'
    Watch     = New-Object System.Diagnostics.Stopwatch
    StepWatch = New-Object System.Diagnostics.Stopwatch
    NetWatch  = New-Object System.Diagnostics.Stopwatch
    NetLast   = [long]0
    NetBase   = [long]0
    Speed     = [double]0
    PipCur    = [long]0
    PipTotal  = [long]0
    PipName   = ''
    StepLines = New-Object 'System.Collections.Generic.List[string]'
    Problems  = New-Object System.Collections.ArrayList
    Info      = New-Object System.Collections.ArrayList
    Fatal     = $null
    Label     = ''
}

function Get-NetBytes {
    $sum = [long]0
    foreach ($ni in [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces()) {
        try {
            if ($ni.OperationalStatus -ne 'Up') { continue }
            if ($ni.NetworkInterfaceType -eq 'Loopback' -or $ni.NetworkInterfaceType -eq 'Tunnel') { continue }
            if ($ni.GetIPProperties().GatewayAddresses.Count -eq 0) { continue }
            $sum += $ni.GetIPStatistics().BytesReceived
        } catch { }
    }
    return $sum
}

function Format-Size([double]$b) {
    if ($b -ge 1e9) { return '{0:0.00} GB' -f ($b / 1e9) }
    if ($b -ge 1e6) { return '{0:0.0} MB' -f ($b / 1e6) }
    return '{0:0} KB' -f ($b / 1e3)
}

function Get-PkgName([string]$u) {
    $f = $u.Split('/')[-1]
    try { $f = [Uri]::UnescapeDataString($f) } catch { }
    $f = $f -replace '\.(whl|tar\.gz|zip)$', ''
    return $f.Split('-')[0]
}

function Update-DlText {
    $stepBytes = $S.NetLast - $S.NetBase
    if ($S.PipTotal -gt 0) {
        $frac = [math]::Min(1, $S.PipCur / $S.PipTotal)
        $name = if ($S.PipName) { $S.PipName + '  ' } else { '' }
        $ui.DlText.Text = '{0}{1} / {2}' -f $name, (Format-Size $S.PipCur), (Format-Size $S.PipTotal)
        $ui.DlFill.Width = $ui.ActivityTrack.ActualWidth * $frac
        $ui.Shimmer.Visibility = 'Hidden'
    } else {
        $ui.DlFill.Width = 0
        $ui.Shimmer.Visibility = 'Visible'
        if ($stepBytes -gt 1e6) {
            $lead = if ($S.PipName) { 'Downloading ' + $S.PipName + '  -  ' } else { 'Downloaded  ' }
            $ui.DlText.Text = $lead + (Format-Size $stepBytes)
        } else {
            $ui.DlText.Text = ' '
        }
    }
    $ui.SpeedText.Text = if ($S.Speed -gt 50e3) { (Format-Size $S.Speed) + '/s' } else { '' }
}

function Update-Net {
    $now = Get-NetBytes
    $dt = $S.NetWatch.Elapsed.TotalSeconds
    $S.NetWatch.Restart()
    if ($dt -le 0) { return }
    $rate = ($now - $S.NetLast) / $dt
    if ($rate -lt 0) { $rate = 0 }
    $S.NetLast = $now
    $S.Speed = 0.6 * $S.Speed + 0.4 * $rate
    Update-DlText
}

function Format-Time([TimeSpan]$ts) {
    '{0}:{1:00}' -f [int][math]::Floor($ts.TotalMinutes), $ts.Seconds
}

function Set-Bar($bar, [double]$value) {
    if ($value -lt 0) { $value = 0 }
    if ($value -gt 100) { $value = 100 }
    $anim = New-Object System.Windows.Media.Animation.DoubleAnimation
    $anim.To = $value
    $anim.Duration = [Windows.Duration]::new([TimeSpan]::FromMilliseconds(380))
    $anim.EasingFunction = New-Object System.Windows.Media.Animation.QuadraticEase
    $bar.BeginAnimation([System.Windows.Controls.Primitives.RangeBase]::ValueProperty, $anim)
}

function Get-StageName([int]$n) {
    if ($n -ge 1 -and $n -le $StageNames.Count) { return $StageNames[$n - 1] }
    return "Stage $n"
}

function Show-Badge($el) {
    if ($el.Visibility -eq 'Visible') { return }
    $el.Opacity = 0
    $el.Visibility = 'Visible'
    $fade = New-Object System.Windows.Media.Animation.DoubleAnimation(0, 1, [Windows.Duration]::new([TimeSpan]::FromMilliseconds(400)))
    $el.BeginAnimation([System.Windows.UIElement]::OpacityProperty, $fade)
}

function Update-Counters {
    $ui.WarnText.Text = if ($S.Warnings -eq 1) { '1 warning' } else { "$($S.Warnings) warnings" }
    $ui.ErrText.Text  = if ($S.Errors -eq 1) { '1 error' } else { "$($S.Errors) errors" }
    if ($S.Warnings -gt 0) { Show-Badge $ui.WarnBadge }
    if ($S.Errors -gt 0) {
        Show-Badge $ui.ErrBadge
        $tb.ProgressState = 'Error'
    }
    $ui.ErrBadge.Margin = if ($S.Warnings -gt 0) { '16,0,0,0' } else { '0' }
}

function Get-ErrorHint($lines) {
    $t = ($lines -join "`n")
    if ($t -match '(?i)no space left|errno 28|not enough space|disk (is )?full') {
        return 'Not enough free disk space - free some space on this drive.'
    }
    if ($t -match '(?i)access is denied|permissionerror|winerror 5\b|errno 13|being used by another process|winerror 32') {
        return 'Access to files was blocked - often by an antivirus. Check Windows Security, Protection history.'
    }
    if ($t -match '(?i)timed? ?out|connection (was )?(reset|refused|aborted)|connectionerror|could not (resolve|connect|fetch)|failed to (download|fetch)|name resolution|getaddrinfo|ssl|certificate|unable to access|status code 5\d\d|network') {
        return 'Network problem - check your internet connection, VPN or proxy.'
    }
    return ''
}

function Add-Problem([string]$kind, [string]$text, [string]$hint = '', $context = $null) {
    [void]$S.Problems.Add(@{ Kind = $kind; Text = $text; Hint = $hint; Context = $context })
    if ($kind -eq 'error') { $S.Errors++ } else { $S.Warnings++ }
    $tbx = New-Object System.Windows.Controls.TextBlock
    $tbx.TextWrapping = 'Wrap'
    $tbx.Margin = '0,3,0,3'
    $icon = New-Object System.Windows.Documents.Run
    $icon.FontFamily = 'Segoe MDL2 Assets'
    if ($kind -eq 'error') {
        $icon.Text = [string][char]0xEA39
        $icon.Foreground = $brush.ConvertFrom('#F0525B')
    } else {
        $icon.Text = [string][char]0xE7BA
        $icon.Foreground = $brush.ConvertFrom('#F2B544')
    }
    $msg = New-Object System.Windows.Documents.Run
    $msg.Text = '   ' + $text
    $msg.Foreground = $brush.ConvertFrom('#EDF3FF')
    $tbx.Inlines.Add($icon)
    $tbx.Inlines.Add($msg)
    if ($hint) {
        $tbx.Inlines.Add((New-Object System.Windows.Documents.LineBreak))
        $h = New-Object System.Windows.Documents.Run
        $h.Text = '      ' + $hint
        $h.FontSize = 12
        $h.Foreground = $brush.ConvertFrom('#7B9BB6')
        $tbx.Inlines.Add($h)
    }
    [void]$ui.ProblemsList.Children.Add($tbx)
    $ui.ProblemsBox.Visibility = 'Visible'
    $ui.ProblemsScroll.ScrollToEnd()
    Update-Counters
}

function On-Step([int]$stage, [string]$label) {
    $S.Index++
    if ($S.Index -gt $S.Total) { $S.Total = $S.Index }
    if ($stage -ne $S.Stage) {
        $S.Stage = $stage
        $S.StageIdx = 0
    }
    $S.StageIdx++
    $st = 0
    if ($StageTotal.ContainsKey($stage)) { $st = [int]$StageTotal[$stage] }
    if ($S.StageIdx -gt $st) { $st = $S.StageIdx; $StageTotal[$stage] = $st }

    $ui.StageText.Text = 'Stage {0} of {1}  -  {2}' -f $stage, $StageNames.Count, (Get-StageName $stage)
    $ui.StageCount.Text = "$($S.StageIdx) / $st"
    $ui.CurrentText.Text = "Installing  $label"
    $ui.TotalCount.Text = '{0} / {1}   {2}%' -f $S.Index, $S.Total, [int][math]::Floor(($S.Index - 1) * 100 / $S.Total)
    Set-Bar $ui.StageBar (($S.StageIdx - 1) * 100 / $st)
    Set-Bar $ui.TotalBar (($S.Index - 1) * 100 / $S.Total)
    $tb.ProgressValue = ($S.Index - 1) / $S.Total
    $S.StepWatch.Restart()
    $S.Label = $label
    $S.StepLines.Clear()
    $S.PipCur = 0
    $S.PipTotal = 0
    $S.PipName = ''
    $S.NetBase = Get-NetBytes
    $S.NetLast = $S.NetBase
    Update-DlText
}

function Handle-Line([string]$raw) {
    $line = $raw.TrimEnd("`r")
    if ($line.StartsWith('##')) {
        $p = $line.Substring(2).Split('|')
        $tag = $p[0].Trim()
        $a1 = if ($p.Count -gt 1) { $p[1].Trim() } else { '' }
        $a2 = if ($p.Count -gt 2) { $p[2].Trim() } else { '' }
        switch ($tag) {
            'STEP' { $n = 0; [void][int]::TryParse($a1, [ref]$n); On-Step $n $a2 }
            'ERR'  {
                $ctx = @($S.StepLines | Select-Object -Last 15)
                Add-Problem 'error' "$a1 - failed" (Get-ErrorHint $S.StepLines) $ctx
            }
            'WARN'  { Add-Problem 'warn' $a1 }
            'FATAL' { if (-not $S.Fatal) { $S.Fatal = @{ Msg = $a1; Hint = $a2 } } }
            'INFO'  { [void]$S.Info.Add($a1) }
            'DONE' { $S.Done = $true }
        }
        return
    }
    if ($line -match '^Progress (\d+) of (\d+)') {
        $S.PipCur = [long]$Matches[1]
        $S.PipTotal = [long]$Matches[2]
        return
    }
    $seg = $line.Split("`r") | Where-Object { $_.Trim() } | Select-Object -Last 1
    if (-not $seg) { return }
    $txt = ($seg -replace $EscRegex, '').TrimEnd()
    if (-not $txt.Trim() -or $txt -match 'Press any key') { return }
    if ($txt -match '^\s*Downloading (\S+)') {
        $S.PipName = Get-PkgName $Matches[1]
        $S.PipCur = 0
        $S.PipTotal = 0
    }
    $S.StepLines.Add($txt)
    if ($S.StepLines.Count -gt 300) { $S.StepLines.RemoveAt(0) }
    $S.Tail.Enqueue($txt)
    while ($S.Tail.Count -gt 200) { [void]$S.Tail.Dequeue() }
}

function Read-Log {
    if (-not (Test-Path -LiteralPath $LogPath)) { return }
    $fs = [IO.File]::Open($LogPath, 'Open', 'Read', 'ReadWrite, Delete')
    try {
        if ($fs.Length -lt $S.Pos) { $S.Pos = 0 }
        $fs.Position = $S.Pos
        $buf = New-Object byte[] 65536
        $sb = New-Object System.Text.StringBuilder
        while (($n = $fs.Read($buf, 0, $buf.Length)) -gt 0) {
            $chars = New-Object char[] ($S.Decoder.GetCharCount($buf, 0, $n))
            $c = $S.Decoder.GetChars($buf, 0, $n, $chars, 0)
            [void]$sb.Append($chars, 0, $c)
        }
        $S.Pos = $fs.Position
    } finally {
        $fs.Dispose()
    }
    if ($sb.Length -eq 0) { return }
    $data = $S.Pending + $sb.ToString()
    $parts = $data.Split("`n")
    $S.Pending = $parts[$parts.Count - 1]
    for ($i = 0; $i -lt $parts.Count - 1; $i++) { Handle-Line $parts[$i] }
}

function Stop-ActivityAnimation {
    $ui.ActX.BeginAnimation([System.Windows.Media.TranslateTransform]::XProperty, $null)
    $ui.ActivityTrack.Visibility = 'Hidden'
}

function New-OverlayIcon([string]$color, [int]$glyph) {
    try {
        $g = New-Object System.Windows.Controls.Grid
        $g.Width = 32
        $g.Height = 32
        $e = New-Object System.Windows.Shapes.Ellipse
        $e.Fill = $brush.ConvertFrom($color)
        [void]$g.Children.Add($e)
        $t = New-Object System.Windows.Controls.TextBlock
        $t.Text = [string][char]$glyph
        $t.FontFamily = 'Segoe MDL2 Assets'
        $t.FontSize = 17
        $t.FontWeight = 'Bold'
        $t.Foreground = $brush.ConvertFrom('#09232D')
        $t.HorizontalAlignment = 'Center'
        $t.VerticalAlignment = 'Center'
        [void]$g.Children.Add($t)
        $g.Measure([Windows.Size]::new(32, 32))
        $g.Arrange([Windows.Rect]::new(0, 0, 32, 32))
        $g.UpdateLayout()
        $rtb = New-Object System.Windows.Media.Imaging.RenderTargetBitmap(32, 32, 96, 96, [Windows.Media.PixelFormats]::Pbgra32)
        $rtb.Render($g)
        $rtb.Freeze()
        return $rtb
    } catch { return $null }
}

function Set-ResultLook([string]$kind) {
    switch ($kind) {
        'ok'   { $color = '#94E4D3'; $glyph = 0xE73E; $sound = [System.Media.SystemSounds]::Asterisk;    $title = 'Installation complete' }
        'warn' { $color = '#F2B544'; $glyph = 0xE7BA; $sound = [System.Media.SystemSounds]::Exclamation; $title = 'Installation complete with errors' }
        default { $color = '#F0525B'; $glyph = 0xE711; $sound = [System.Media.SystemSounds]::Hand;       $title = 'Installation stopped' }
    }
    $ui.ResultIcon.Background = $brush.ConvertFrom($color)
    $ui.ResultGlyph.Text = [string][char]$glyph
    $ui.ResultGlyph.Foreground = $brush.ConvertFrom('#09232D')
    $win.Title = "$title - $AppTitle"
    $ov = New-OverlayIcon $color $glyph
    if ($ov) { $tb.Overlay = $ov }
    try { $sound.Play() } catch { }
    $ui.ResultBox.Opacity = 0
    $d = [Windows.Duration]::new([TimeSpan]::FromMilliseconds(350))
    $ui.ResultBox.BeginAnimation([System.Windows.UIElement]::OpacityProperty, (New-Object System.Windows.Media.Animation.DoubleAnimation(0, 1, $d)))
    $slide = New-Object System.Windows.Media.TranslateTransform
    $ui.ResultBox.RenderTransform = $slide
    $mv = New-Object System.Windows.Media.Animation.DoubleAnimation(12, 0, $d)
    $mv.EasingFunction = New-Object System.Windows.Media.Animation.QuadraticEase
    $slide.BeginAnimation([System.Windows.Media.TranslateTransform]::YProperty, $mv)
}

function Finish {
    $S.Finished = $true
    $timer.Stop()
    Compact-Log
    $S.Watch.Stop()
    $S.StepWatch.Stop()
    Stop-ActivityAnimation
    $ui.StepTime.Text = ''
    $ui.DlText.Text = ' '
    $ui.SpeedText.Text = ''
    $ui.DlFill.Width = 0
    $total = Format-Time $S.Watch.Elapsed
    $ui.ElapsedText.Text = "Total time  $total"
    $ui.ResultBox.Visibility = 'Visible'
    $ui.ActionBtn.Content = 'Close'
    $ui.ActionBtn.Style = $win.FindResource('BtnPrimary')

    if ($S.Done) {
        Set-Bar $ui.StageBar 100
        Set-Bar $ui.TotalBar 100
        $ui.StageText.Text = 'Installation complete'
        $ui.StageCount.Text = ''
        $ui.CurrentText.Text = ''
        $ui.TotalCount.Text = "$($S.Total) / $($S.Total)   100%"
        $tb.ProgressValue = 1
        if ($S.Errors -gt 0) {
            $word = if ($S.Errors -eq 1) { 'error' } else { 'errors' }
            $ui.ResultText.Text = "Finished in $total with $($S.Errors) $word."
            $ui.ResultText.Foreground = $brush.ConvertFrom('#F2B544')
            $ui.HintText.Text = 'ComfyUI will most likely start, but the failed parts above may not work. If you need help, use Copy details and paste the result where you ask.'
            $ui.HintText.Visibility = 'Visible'
            $tb.ProgressState = 'Error'
        } else {
            $ui.ResultText.Text = "ComfyUI-Easy-Install was installed successfully in $total."
            $ui.HintText.Text = if (Test-Path -LiteralPath $LauncherLnk) { "Start it now, or later with the 'ComfyUI-EZi Launcher' shortcut on your Desktop." } else { 'You can start it from the ComfyUI-Easy-Install folder.' }
            $ui.HintText.Visibility = 'Visible'
            $ui.ResultText.Foreground = $brush.ConvertFrom('#94E4D3')
            $tb.ProgressState = 'Normal'
        }
        if (Test-Path -LiteralPath $InstallDir) { $ui.FolderBtn.Visibility = 'Visible' }
    } else {
        $red = $brush.ConvertFrom('#F0525B')
        $ui.StageBar.Foreground = $red
        $ui.TotalBar.Foreground = $red
        $ui.StageText.Text = 'Installation stopped'
        $ui.ResultText.Foreground = $red
        $ui.HintText.Visibility = 'Visible'
        if ($S.Fatal) {
            $ui.ResultText.Text = $S.Fatal.Msg
            $ui.HintText.Text = $S.Fatal.Hint
        } else {
            $ui.ResultText.Text = 'The installation stopped unexpectedly. The last messages:'
            $ui.HintText.Text = 'If you need help, use Copy details and paste the result where you ask.'
            $ui.LogTail.Text = (@($S.Tail.ToArray()) | Select-Object -Last 12) -join "`r`n"
            $ui.LogTail.Visibility = 'Visible'
            $ui.LogTail.ScrollToEnd()
        }
        $tb.ProgressState = 'Error'
        $tb.ProgressValue = 1
    }
    if (-not $S.Done -or $S.Problems.Count -gt 0) { $ui.CopyBtn.Visibility = 'Visible' }
    $ui.ActivityTrack.Visibility = 'Collapsed'
    if ($S.Done -and $S.Errors -eq 0) { Set-ResultLook 'ok' }
    elseif ($S.Done) { Set-ResultLook 'warn' }
    else { Set-ResultLook 'fail' }
    if ($S.Done -and (Test-Path -LiteralPath $LauncherLnk)) {
        $ui.ActionBtn.Style = $win.FindResource('Btn')
        $ui.LaunchBtn.Visibility = 'Visible'
        [void]$ui.LaunchBtn.Focus()
    } else {
        [void]$ui.ActionBtn.Focus()
    }
    Bring-ToFront
}

function Get-WindowsName {
    try {
        $os = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
        return "$($os.Caption) build $($os.BuildNumber)"
    } catch {
        return [Environment]::OSVersion.VersionString
    }
}

function Build-Report {
    $L = New-Object System.Collections.Generic.List[string]
    if ($S.Done) {
        $result = if ($S.Errors -gt 0) { "Completed with $($S.Errors) error(s)" } else { 'Completed' }
    } else {
        $result = 'Stopped'
    }
    $L.Add('```')
    $L.Add("ComfyUI-Easy-Install $Version - installer report")
    $L.Add("Result:   $result")
    if ($S.Fatal) { $L.Add("Reason:   $($S.Fatal.Msg)") }
    $L.Add("Windows:  $(Get-WindowsName)")
    foreach ($i in $S.Info) { $L.Add("System:   $i") }
    $L.Add("Folder:   $BaseDir")
    $L.Add("Time:     $(Format-Time $S.Watch.Elapsed)")
    $L.Add("Step:     $($S.Index) / $($S.Total)  $($S.Label)")
    if ($S.Problems.Count -gt 0) {
        $L.Add('')
        $L.Add('Problems:')
        foreach ($p in $S.Problems) {
            $line = "  [$($p.Kind)] $($p.Text)"
            if ($p.Hint) { $line += "  ($($p.Hint))" }
            $L.Add($line)
        }
    }
    foreach ($p in $S.Problems) {
        if ($p.Context) {
            $L.Add('')
            $L.Add("--- $($p.Text) ---")
            foreach ($c in $p.Context) { $L.Add($c) }
        }
    }
    if (-not $S.Done) {
        $L.Add('')
        $L.Add('--- last log lines ---')
        foreach ($c in @($S.Tail.ToArray() | Select-Object -Last 25)) { $L.Add($c) }
    }
    $L.Add('```')
    return ($L -join "`r`n")
}

function Copy-Details {
    $text = Build-Report
    $ok = $false
    for ($i = 0; $i -lt 5 -and -not $ok; $i++) {
        try { [System.Windows.Clipboard]::SetText($text); $ok = $true } catch { Start-Sleep -Milliseconds 100 }
    }
    $ui.CopyBtn.Content = if ($ok) { 'Copied' } else { 'Copy failed' }
    $t = New-Object System.Windows.Threading.DispatcherTimer
    $t.Interval = [TimeSpan]::FromSeconds(2)
    $t.Add_Tick({ $ui.CopyBtn.Content = 'Copy details'; $this.Stop() })
    $t.Start()
}

function Stop-Worker {
    if ($S.Proc -and -not $S.Proc.HasExited) {
        try { & "$env:SystemRoot\System32\taskkill.exe" /PID $S.Proc.Id /T /F 2>&1 | Out-Null } catch { }
    }
}

function Start-Worker {
    $S.DirExisted = Test-Path -LiteralPath $InstallDir
    try { Remove-Item -LiteralPath $LogPath -Force -ErrorAction SilentlyContinue } catch { }
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "$env:SystemRoot\System32\cmd.exe"
    $psi.Arguments = '/d /s /c ""' + $BatPath + '" CEI_WORKER <nul >>"' + $LogPath + '" 2>&1"'
    $psi.WorkingDirectory = $BaseDir
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    $S.Proc = [Diagnostics.Process]::Start($psi)
    $S.Watch.Start()
    $S.NetLast = Get-NetBytes
    $S.NetBase = $S.NetLast
    $S.NetWatch.Start()
    $tb.ProgressState = 'Normal'
    $tb.ProgressValue = 0

    $anim = New-Object System.Windows.Media.Animation.DoubleAnimation
    $anim.From = -110
    $anim.To = 600
    $anim.Duration = [Windows.Duration]::new([TimeSpan]::FromMilliseconds(1500))
    $anim.RepeatBehavior = [System.Windows.Media.Animation.RepeatBehavior]::Forever
    $ui.ActX.BeginAnimation([System.Windows.Media.TranslateTransform]::XProperty, $anim)

    $timer.Start()
}

function Get-CleanLog {
    $enc = [Text.Encoding]::GetEncoding(28591)
    $fs = [IO.File]::Open($LogPath, 'Open', 'Read', 'ReadWrite, Delete')
    $sr = New-Object IO.StreamReader($fs, $enc)
    $raw = $sr.ReadToEnd()
    $sr.Dispose()
    $out = New-Object System.Text.StringBuilder
    foreach ($line in ($raw -replace $EscRegex, '').Split("`n")) {
        $l = $line.TrimEnd("`r")
        if ($l.Contains("`r")) { $l = ($l.Split("`r") | Where-Object { $_.Trim() } | Select-Object -Last 1) }
        if ($l -match '^Progress \d+ of \d+$') { continue }
        [void]$out.Append($l).Append("`r`n")
    }
    return $out.ToString()
}

function Compact-Log {
    try {
        if (-not (Test-Path -LiteralPath $LogPath)) { return }
        $clean = Get-CleanLog
        [IO.File]::WriteAllText($LogPath, $clean, [Text.Encoding]::GetEncoding(28591))
    } catch { }
}

function Open-Log {
    if (-not (Test-Path -LiteralPath $LogPath)) { return }
    try {
        if ($S.Finished) {
            $view = $LogPath
        } else {
            $view = Join-Path $env:TEMP 'ComfyUI-Easy-Install-log.txt'
            [IO.File]::WriteAllText($view, (Get-CleanLog), [Text.Encoding]::GetEncoding(28591))
        }
        Start-Process -FilePath "$env:SystemRoot\System32\notepad.exe" -ArgumentList "`"$view`""
    } catch { }
}

$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromMilliseconds(200)
$timer.Add_Tick({
    try {
        Read-Log
        $ui.ElapsedText.Text = 'Elapsed  ' + (Format-Time $S.Watch.Elapsed)
        if ($S.StepWatch.IsRunning) { $ui.StepTime.Text = Format-Time $S.StepWatch.Elapsed }
        if ($S.NetWatch.IsRunning -and $S.NetWatch.ElapsedMilliseconds -ge 1000) { Update-Net }
        elseif ($S.PipTotal -gt 0) { Update-DlText }
        if (-not $S.Finished -and $S.Proc -and $S.Proc.HasExited) {
            Read-Log
            if ($S.Pending) { Handle-Line $S.Pending; $S.Pending = '' }
            Finish
        }
    } catch { }
})

$win.Add_MouseLeftButtonDown({ try { $win.DragMove() } catch { } })
$ui.MinBtn.Add_Click({ $win.WindowState = 'Minimized' })
$ui.CloseBtn.Add_Click({ $win.Close() })
$ui.ActionBtn.Add_Click({ $win.Close() })
$ui.LogBtn.Add_Click({ Open-Log })
$ui.CopyBtn.Add_Click({ Copy-Details })
$ui.LaunchBtn.Add_Click({
    try { Start-Process -FilePath $LauncherLnk -WorkingDirectory $InstallDir } catch { }
    $win.Close()
})
$ui.FolderBtn.Add_Click({ Start-Process -FilePath "$env:SystemRoot\explorer.exe" -ArgumentList "`"$InstallDir`"" })

function Show-StopDialog {
    if ($ui.Overlay.Visibility -eq 'Visible') { return }
    if ($S.DirExisted) {
        $ui.DelCheck.IsChecked = $false
        $ui.DelCheck.Visibility = 'Collapsed'
    }
    $ui.Overlay.Opacity = 0
    $ui.Overlay.Visibility = 'Visible'
    $d = [Windows.Duration]::new([TimeSpan]::FromMilliseconds(160))
    $fade = New-Object System.Windows.Media.Animation.DoubleAnimation(0, 1, $d)
    $ui.Overlay.BeginAnimation([System.Windows.UIElement]::OpacityProperty, $fade)
    $grow = New-Object System.Windows.Media.Animation.DoubleAnimation(0.94, 1, $d)
    $grow.EasingFunction = New-Object System.Windows.Media.Animation.QuadraticEase
    $ui.CardScale.BeginAnimation([System.Windows.Media.ScaleTransform]::ScaleXProperty, $grow)
    $ui.CardScale.BeginAnimation([System.Windows.Media.ScaleTransform]::ScaleYProperty, $grow)
    [void]$ui.DlgKeep.Focus()
}

function Hide-StopDialog {
    $ui.Overlay.BeginAnimation([System.Windows.UIElement]::OpacityProperty, $null)
    $ui.Overlay.Visibility = 'Collapsed'
}

function Remove-Unfinished {
    if ($S.DirExisted -or -not (Test-Path -LiteralPath $InstallDir)) { return }
    $cmd = 'ping -n 3 127.0.0.1 >nul & attrib -r "' + $InstallDir + '\*" /s /d >nul 2>&1 & rd /s /q "' + $InstallDir + '"'
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "$env:SystemRoot\System32\cmd.exe"
    $psi.Arguments = '/d /s /c "' + $cmd + '"'
    $psi.WorkingDirectory = $BaseDir
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    [void][Diagnostics.Process]::Start($psi)
}

$ui.DlgKeep.Add_Click({ Hide-StopDialog })
$ui.DlgStop.Add_Click({
    $S.StopConfirmed = $true
    $timer.Stop()
    Stop-Worker
    if ($ui.DelCheck.IsChecked) { Remove-Unfinished }
    $win.Close()
})
$win.Add_PreviewKeyDown({
    param($sender, $e)
    if ($e.Key -eq 'Escape' -and $ui.Overlay.Visibility -eq 'Visible') { Hide-StopDialog; $e.Handled = $true }
})

$win.Add_Closing({
    param($sender, $e)
    if ($S.StopConfirmed) { return }
    if ($S.Proc -and -not $S.Proc.HasExited) {
        $e.Cancel = $true
        Show-StopDialog
    }
})

function Bring-ToFront {
    try {
        $win.WindowState = 'Normal'
        $win.Topmost = $true
        [void]$win.Activate()
        [void]$win.Focus()
        $t = New-Object System.Windows.Threading.DispatcherTimer
        $t.Interval = [TimeSpan]::FromMilliseconds(600)
        $t.Add_Tick({ $win.Topmost = $false; $this.Stop() })
        $t.Start()
    } catch { }
}

$win.Add_ContentRendered({
    Bring-ToFront
    if ($Flag) {
        if (Test-Path -LiteralPath "$Flag.cancel") {
            try { Remove-Item -LiteralPath "$Flag.cancel" -Force } catch { }
            $win.Close()
            return
        }
        try { [IO.File]::WriteAllText($Flag, 'ok') } catch { }
    }
    Start-Worker
})

try {
    [void]$win.ShowDialog()
} catch {
    Write-FailFlag
    Stop-Worker
    exit 1
}
