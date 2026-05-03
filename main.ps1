Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore

$filePath = $args[0]

function Show-ErrorPopup {
    param([string]$ErrorMessage)

    $xaml3 = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        WindowStyle="None"
        AllowsTransparency="True"
        Background="Transparent"
        Width="300" Height="140"
        Topmost="True"
        WindowStartupLocation="CenterScreen">

    <Border CornerRadius="10" Background="#1E1E1E" Padding="10">
        <Grid>

            <TextBlock Name="CloseBtn3"
                       Text="✕"
                       Foreground="#AAAAAA"
                       FontSize="11"
                       HorizontalAlignment="Right"
                       VerticalAlignment="Top"
                       Cursor="Hand"/>

            <StackPanel VerticalAlignment="Center" HorizontalAlignment="Center" Margin="10">
                <TextBlock Text="Error"
                           Foreground="#FF4444"
                           FontSize="13"
                           FontWeight="Bold"
                           Margin="0,0,0,8"/>

                <TextBlock Name="ErrorMessage"
                           Foreground="#EAEAEA"
                           FontSize="11"
                           TextWrapping="Wrap"
                           MaxWidth="280"/>
            </StackPanel>
        </Grid>
    </Border>
</Window>
"@

    $reader3 = New-Object System.Xml.XmlNodeReader ([xml]$xaml3)
    $win3 = [Windows.Markup.XamlReader]::Load($reader3)

    $closeBtn3 = $win3.FindName("CloseBtn3")
    $errorMessageBlock = $win3.FindName("ErrorMessage")
    
    $errorMessageBlock.Text = $ErrorMessage

    # draggable
    $win3.Add_MouseDown({ $win3.DragMove() })

    # close
    $closeBtn3.Add_MouseLeftButtonDown({
        $win3.Close()
    })

    $win3.ShowDialog()
}

if (-not $filePath) {
    Show-ErrorPopup -ErrorMessage "No file provided"
    exit
}

$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        WindowStyle="None"
        AllowsTransparency="True"
        Background="Transparent"
        Width="260" Height="140"
        Topmost="True"
        WindowStartupLocation="CenterScreen">

    <Border CornerRadius="12" Background="#1E1E1E" Padding="10">
        <Grid>

            <!-- Close -->
            <TextBlock Name="CloseBtn"
                       Text="✕"
                       Foreground="#AAAAAA"
                       FontSize="12"
                       HorizontalAlignment="Right"
                       VerticalAlignment="Top"
                       Cursor="Hand"/>

            <StackPanel Margin="0,10,0,0">

                <TextBlock Text="Password (optional)"
                           Foreground="#EAEAEA"
                           FontSize="14"
                           Margin="0,0,0,6"/>

                <TextBox Name="PasswordBox"
                         Height="26"
                         Background="#2A2A2A"
                         Foreground="#EAEAEA"
                         BorderThickness="0"
                         Padding="6"
                         Margin="0,0,0,8"/>

                <Button Name="UploadButton"
                        Content="Upload"
                        Height="28"
                        Background="#3A3A3A"
                        Foreground="#FFFFFF"
                        BorderThickness="0"/>
            </StackPanel>
        </Grid>
    </Border>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader ([xml]$xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

$btn = $window.FindName("UploadButton")
$box = $window.FindName("PasswordBox")
$closeBtn = $window.FindName("CloseBtn")

$window.Add_MouseDown({ $window.DragMove() })

$closeBtn.Add_MouseLeftButtonDown({
    $window.Close()
})

function Show-SuccessPopup {

    $xaml2 = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        WindowStyle="None"
        AllowsTransparency="True"
        Background="Transparent"
        Width="200" Height="70"
        Topmost="True"
        WindowStartupLocation="CenterScreen">

    <Border CornerRadius="10" Background="#1E1E1E" Padding="10">
        <Grid>

            <TextBlock Name="CloseBtn2"
                       Text="✕"
                       Foreground="#AAAAAA"
                       FontSize="11"
                       HorizontalAlignment="Right"
                       VerticalAlignment="Top"
                       Cursor="Hand"/>

            <TextBlock Text="Link copied"
                       Foreground="#EAEAEA"
                       FontSize="13"
                       HorizontalAlignment="Center"
                       VerticalAlignment="Center"/>
        </Grid>
    </Border>
</Window>
"@

    $reader2 = New-Object System.Xml.XmlNodeReader ([xml]$xaml2)
    $win2 = [Windows.Markup.XamlReader]::Load($reader2)

    $closeBtn2 = $win2.FindName("CloseBtn2")

    # draggable
    $win2.Add_MouseDown({ $win2.DragMove() })

    # close
    $closeBtn2.Add_MouseLeftButtonDown({
        $win2.Close()
    })

    $win2.ShowDialog()
}

$btn.Add_Click({

    $password = $box.Text

    try {
        $apiUrl = Invoke-RestMethod "https://raw.githubusercontent.com/SaaranshDx/GhostDrop/main/serverurl"

        $response = Invoke-RestMethod -Uri "$apiUrl/upload/" `
            -Method Post `
            -Headers @{ password = $password } `
            -Form @{ file = Get-Item $filePath }

        $link = "https://link.ghostdrop.qzz.io/$($response.id)/"

        Set-Clipboard -Value $link

        $window.Close()

        Show-SuccessPopup

    } catch {
        $window.Close()
        Show-ErrorPopup -ErrorMessage $_.Exception.Message
    }
})

$window.ShowDialog()