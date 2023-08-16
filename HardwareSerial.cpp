/*
  HardwareSerial.cpp - Hardware serial library for Wiring
  Copyright (c) 2006 Nicholas Zambetti.  All right reserved.

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  
  Modified 23 November 2006 by David A. Mellis
  Modified 28 September 2010 by Mark Sproul
  Modified 14 August 2012 by Alarus
  Modified 3 December 2013 by Matthijs Kooijman
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <inttypes.h>
#include <util/atomic.h>
#include "Arduino.h"
#include "shims.h"

#include "HardwareSerial.h"

// this next line disables the entire HardwareSerial.cpp, 
// this is so I can support Attiny series and any other chip without a uart
#if defined(HAVE_HWSERIAL0) || defined(HAVE_HWSERIAL1) || defined(HAVE_HWSERIAL2) || defined(HAVE_HWSERIAL3)

// serialEvent, serialEvent1, serialEvent2, serialEvent3 not supported

HardwareSerial::HardwareSerial(
  volatile uint8_t *ubrrh, volatile uint8_t *ubrrl,
  volatile uint8_t *ucsra, volatile uint8_t *ucsrb,
  volatile uint8_t *ucsrc, volatile uint8_t *udr)
// :
//     _ubrrh(ubrrh), _ubrrl(ubrrl),
//     _ucsra(ucsra), _ucsrb(ucsrb), _ucsrc(ucsrc),
//     _udr(udr)
{
}

// Public Methods //////////////////////////////////////////////////////////////

void HardwareSerial::begin(unsigned long baud, byte config)
{
  _setupSerial(baud);
}

void HardwareSerial::end()
{
  // not supported
}

int HardwareSerial::available(void)
{
  return _available();
}

int HardwareSerial::peek(void)
{
  // not supported
  return -1;
}

int HardwareSerial::read(void)
{
  return _receiveByte();
}

int HardwareSerial::availableForWrite(void)
{
  // not supported
  return 0;
}

void HardwareSerial::flush()
{
  // not supported
  // noop
}

size_t HardwareSerial::write(uint8_t c)
{
  _sendByte(c);
  return 1;
}

#endif // whole file
