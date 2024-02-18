# Notes

## PS cmdlets to get VM skus for Ubuntu 

```powershell
Get-AzVMImageOffer -Location "UK South" -PublisherName "Canonical"

Get-AzVMImageSku -Location "UK South" -PublisherName "Canonical" -Offer "Ubuntu"

Get-AzVMImageSku -Location "UK South" -PublisherName "Canonical" -Offer "Ubuntu" | fc
```