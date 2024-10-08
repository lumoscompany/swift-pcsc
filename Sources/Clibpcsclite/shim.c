//
//  Created by Adam Stragner
//

#include <Clibpcsclite.h>

#if __has_include(<libpcsclite_linux.h>)
#include <libpcsclite_linux.h>
#elif __has_include(<libpcsclite_macos.h>)
#include <libpcsclite_macos.h>
#else
#error Unsupported platform (macOS and Lunux are supported)
#endif

#undef SCardControl

const CSCARD_IO_REQUEST cg_rgSCardT0Pci = { CSCARD_PROTOCOL_T0, sizeof(CSCARD_IO_REQUEST) };
const CSCARD_IO_REQUEST cg_rgSCardT1Pci = { CSCARD_PROTOCOL_T1, sizeof(CSCARD_IO_REQUEST) };
const CSCARD_IO_REQUEST cg_rgSCardRawPci = { CSCARD_PROTOCOL_RAW, sizeof(CSCARD_IO_REQUEST) };

int32_t CSCardEstablishContext(uint32_t dwScope,
                               const void *pvReserved1,
                               const void *pvReserved2,
                               LPSCARDCONTEXT phContext) {
    return SCardEstablishContext(dwScope, pvReserved1, pvReserved2, phContext);
}

int32_t CSCardReleaseContext(SCARDCONTEXT hContext)
{
    return SCardReleaseContext(hContext);
}

int32_t CSCardIsValidContext(SCARDCONTEXT hContext)
{
    return SCardIsValidContext(hContext);
}

int32_t CSCardSetTimeout(SCARDCONTEXT hContext,
                         uint32_t dwTimeout)
{
    return SCardSetTimeout(hContext, dwTimeout);
}

int32_t CSCardConnect(SCARDCONTEXT hContext,
                      const char *szReader,
                      uint32_t dwShareMode,
                      uint32_t dwPreferredProtocols,
                      LPSCARDHANDLE phCard,
                      uint32_t *pdwActiveProtocol)
{
    return SCardConnect(hContext, szReader, dwShareMode, dwPreferredProtocols, phCard, pdwActiveProtocol);
}

int32_t CSCardReconnect(SCARDHANDLE hCard,
                        uint32_t dwShareMode,
                        uint32_t dwPreferredProtocols,
                        uint32_t dwInitialization,
                        uint32_t *pdwActiveProtocol)
{
    return SCardReconnect(hCard, dwShareMode, dwPreferredProtocols, dwInitialization, pdwActiveProtocol);
}

int32_t CSCardDisconnect(SCARDHANDLE hCard,
                         uint32_t dwDisposition)
{
    return SCardDisconnect(hCard, dwDisposition);
}

int32_t CSCardBeginTransaction(SCARDHANDLE hCard)
{
    return SCardBeginTransaction(hCard);
}

int32_t CSCardEndTransaction(SCARDHANDLE hCard,
                             uint32_t dwDisposition)
{
    return SCardEndTransaction(hCard, dwDisposition);
}

int32_t CSCardCancelTransaction(SCARDHANDLE hCard)
{
    return SCardCancelTransaction(hCard);
}

int32_t CSCardStatus(SCARDHANDLE hCard,
                     char *mszReaderNames,
                     uint32_t *pcchReaderLen,
                     uint32_t *pdwState,
                     uint32_t *pdwProtocol,
                     unsigned char *pbAtr,
                     uint32_t *pcbAtrLen)
{
    return SCardStatus(hCard, mszReaderNames, pcchReaderLen, pdwState, pdwProtocol, pbAtr, pcbAtrLen);
}

int32_t CSCardGetStatusChange(SCARDCONTEXT hContext,
                              uint32_t dwTimeout,
                              CLPSCARD_READERSTATE_A rgReaderStates,
                              uint32_t cReaders)
{
    return SCardGetStatusChange(hContext, dwTimeout, (LPSCARD_READERSTATE_A)rgReaderStates, cReaders);
}

int32_t CSCardControl(SCARDHANDLE hCard,
                      const void *pbSendBuffer,
                      uint32_t cbSendLength,
                      void *pbRecvBuffer,
                      uint32_t *pcbRecvLength)
{
    return SCardControl(hCard, pbSendBuffer, cbSendLength, pbRecvBuffer, pcbRecvLength);
}

int32_t CSCardControl132(SCARDHANDLE hCard,
                         uint32_t dwControlCode,
                         const void *pbSendBuffer,
                         uint32_t cbSendLength,
                         void *pbRecvBuffer,
                         uint32_t cbRecvLength,
                         uint32_t *lpBytesReturned)
{
    return SCardControl132(hCard, dwControlCode, pbSendBuffer, cbSendLength, pbRecvBuffer, cbRecvLength, lpBytesReturned);
}

int32_t CSCardTransmit(SCARDHANDLE hCard,
                       CLPCSCARD_IO_REQUEST pioSendPci,
                       const unsigned char *pbSendBuffer, uint32_t cbSendLength,
                       CLPSCARD_IO_REQUEST pioRecvPci,
                       unsigned char *pbRecvBuffer, uint32_t *pcbRecvLength)
{
    return SCardTransmit(hCard,
                         (LPCSCARD_IO_REQUEST)pioSendPci,
                         pbSendBuffer, cbSendLength,
                         (LPSCARD_IO_REQUEST)pioRecvPci,
                         pbRecvBuffer, pcbRecvLength);
}

int32_t CSCardListReaderGroups(SCARDCONTEXT hContext,
                               char *mszGroups,
                               uint32_t *pcchGroups)
{
    return SCardListReaderGroups(hContext, mszGroups, pcchGroups);
}

int32_t CSCardListReaders(SCARDCONTEXT hContext,
                          const char *mszGroups,
                          char *mszReaders,
                          uint32_t *pcchReaders)
{
    return SCardListReaders(hContext, mszGroups, mszReaders, pcchReaders);
}

int32_t CSCardCancel(SCARDCONTEXT hContext)
{
    return SCardCancel(hContext);
}

int32_t CSCardGetAttrib(SCARDHANDLE hCard,
                        uint32_t dwAttrId,
                        uint8_t *pbAttr,
                        uint32_t *pcbAttrLen)
{
    return SCardGetAttrib(hCard, dwAttrId, pbAttr, pcbAttrLen);
}

int32_t CSCardSetAttrib(SCARDHANDLE hCard,
                        uint32_t dwAttrId,
                        const uint8_t *pbAttr,
                        uint32_t cbAttrLen)
{
    return SCardSetAttrib(hCard, dwAttrId, pbAttr, cbAttrLen);
}
