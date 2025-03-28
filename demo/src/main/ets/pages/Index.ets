import {JuggleIm} from 'jimsdk';
import { TextMessage } from 'jimsdk/src/main/ets/entries/message';
import { Home } from 'home';
import { BaseConstants, BreakpointConstants } from 'base';


@Entry
@Component
struct Index {
  @StorageLink('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;

  build() {
    GridRow({
      columns: {
        sm: BreakpointConstants.GRID_ROW_COLUMNS[2],
        md: BreakpointConstants.GRID_ROW_COLUMNS[0],
        lg: BreakpointConstants.GRID_ROW_COLUMNS[0]
      }
    }) {
      GridCol({ span: {
        sm: BreakpointConstants.GRID_COLUMN_SPANS[5],
        md: BreakpointConstants.GRID_COLUMN_SPANS[0],
        lg: BreakpointConstants.GRID_COLUMN_SPANS[0]
      } }) {
        Column() {
          Home()
        }
        .width(BaseConstants.FULL_HEIGHT)
        .height(BaseConstants.FULL_HEIGHT)

      }
      .height(BaseConstants.FULL_PERCENT)
      .width(BaseConstants.FULL_PERCENT)
    }
    .onBreakpointChange((breakPoints) => {
      this.currentBreakpoint = breakPoints;
    })
  }
}