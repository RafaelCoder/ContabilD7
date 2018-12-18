object ovF_Principal: TovF_Principal
  Left = 192
  Top = 117
  Width = 924
  Height = 480
  Caption = 'ovF_Principal'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = ovMM
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  PixelsPerInch = 96
  TextHeight = 13
  object ovMM: TMainMenu
    Left = 384
    Top = 168
    object Cadastros1: TMenuItem
      Caption = 'Cadastros'
      object Contas1: TMenuItem
        Caption = 'Contas'
      end
    end
    object Lanamentos1: TMenuItem
      Caption = 'Lan'#231'amentos'
      object LivroDirio1: TMenuItem
        Caption = 'Livro Di'#225'rio'
      end
    end
    object Relatrios1: TMenuItem
      Caption = 'Relat'#243'rios'
      object LivroRazao1: TMenuItem
        Caption = 'Livro Razao'
      end
      object BalancetedeVerificao1: TMenuItem
        Caption = 'Balancete de Verifica'#231#227'o'
      end
      object LivroDirio2: TMenuItem
        Caption = 'Livro Di'#225'rio'
      end
      object DemonstrativodeResultadodoPerodo1: TMenuItem
        Caption = 'Demonstrativo de Resultado do Per'#237'odo'
      end
      object Balanopatrimonial1: TMenuItem
        Caption = 'Balan'#231'o patrimonial'
      end
    end
  end
end
