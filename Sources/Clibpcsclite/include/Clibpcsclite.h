//
//  Created by Adam Stragner
//

#ifndef _Clibpcsclite_h
#define _Clibpcsclite_h

#ifdef __cplusplus
extern "C"
{
#endif

#include <stdint.h>

#ifndef C_PCSC_API
#define C_PCSC_API extern __attribute__((visibility ("default")))
#endif

typedef int32_t SCARDCONTEXT;
typedef SCARDCONTEXT *PSCARDCONTEXT;
typedef SCARDCONTEXT *LPSCARDCONTEXT;

typedef int32_t SCARDHANDLE;
typedef SCARDHANDLE *PSCARDHANDLE;
typedef SCARDHANDLE *LPSCARDHANDLE;

#ifdef __APPLE__
#pragma pack(1)
#else
#pragma pack(push, 1)
#endif

typedef struct
{
    const char *szReader;
    void *pvUserData;
    uint32_t dwCurrentState;
    uint32_t dwEventState;
    uint32_t cbAtr;
    unsigned char *rgbAtr; // [33]
} CSCARD_READERSTATE_A;

typedef CSCARD_READERSTATE_A CSCARD_READERSTATE, *CPSCARD_READERSTATE_A, *CLPSCARD_READERSTATE_A;

typedef struct
{
    uint32_t dwProtocol;
    uint32_t cbPciLength;
} CSCARD_IO_REQUEST, *CPSCARD_IO_REQUEST, *CLPSCARD_IO_REQUEST;

typedef CSCARD_IO_REQUEST * CLPCSCARD_IO_REQUEST;
C_PCSC_API const CSCARD_IO_REQUEST cg_rgSCardT0Pci, cg_rgSCardT1Pci, cg_rgSCardRawPci;

#ifdef __APPLE__
#pragma pack()
#else
#pragma pack(pop)
#endif

#define CSCARD_PROTOCOL_UNDEFINED    0x0000
#define CSCARD_PROTOCOL_UNSET        SCARD_PROTOCOL_UNDEFINED
#define CSCARD_PROTOCOL_T0           0x0001
#define CSCARD_PROTOCOL_T1           0x0002
#define CSCARD_PROTOCOL_RAW          0x0004
#define CSCARD_PROTOCOL_T15          0x0008

C_PCSC_API int32_t CSCardEstablishContext(uint32_t dwScope,
                                          const void *pvReserved1,
                                          const void *pvReserved2,
                                          LPSCARDCONTEXT phContext);

C_PCSC_API int32_t CSCardReleaseContext(SCARDCONTEXT hContext);
C_PCSC_API int32_t CSCardIsValidContext(SCARDCONTEXT hContext);
C_PCSC_API int32_t CSCardSetTimeout(SCARDCONTEXT hContext, uint32_t dwTimeout);

C_PCSC_API int32_t CSCardConnect(SCARDCONTEXT hContext,
                                 const char *szReader,
                                 uint32_t dwShareMode,
                                 uint32_t dwPreferredProtocols,
                                 LPSCARDHANDLE phCard,
                                 uint32_t *pdwActiveProtocol);

C_PCSC_API int32_t CSCardReconnect(SCARDHANDLE hCard,
                                   uint32_t dwShareMode,
                                   uint32_t dwPreferredProtocols,
                                   uint32_t dwInitialization,
                                   uint32_t *pdwActiveProtocol);

C_PCSC_API int32_t CSCardDisconnect(SCARDHANDLE hCard, uint32_t dwDisposition);
C_PCSC_API int32_t CSCardBeginTransaction(SCARDHANDLE hCard);
C_PCSC_API int32_t CSCardEndTransaction(SCARDHANDLE hCard, uint32_t dwDisposition);
C_PCSC_API int32_t CSCardCancelTransaction(SCARDHANDLE hCard);

C_PCSC_API int32_t CSCardStatus(SCARDHANDLE hCard,
                                char *mszReaderNames,
                                uint32_t *pcchReaderLen,
                                uint32_t *pdwState,
                                uint32_t *pdwProtocol,
                                unsigned char *pbAtr,
                                uint32_t *pcbAtrLen);

C_PCSC_API int32_t CSCardGetStatusChange(SCARDCONTEXT hContext,
                                         uint32_t dwTimeout,
                                         CLPSCARD_READERSTATE_A rgReaderStates,
                                         uint32_t cReaders);

C_PCSC_API int32_t CSCardControl(SCARDHANDLE hCard,
                                 const void *pbSendBuffer,
                                 uint32_t cbSendLength,
                                 void *pbRecvBuffer,
                                 uint32_t *pcbRecvLength);

C_PCSC_API int32_t CSCardControl132(SCARDHANDLE hCard,
                                    uint32_t dwControlCode,
                                    const void *pbSendBuffer,
                                    uint32_t cbSendLength,
                                    void *pbRecvBuffer,
                                    uint32_t cbRecvLength,
                                    uint32_t *lpBytesReturned);

C_PCSC_API int32_t CSCardTransmit(SCARDHANDLE hCard,
                                  CLPCSCARD_IO_REQUEST pioSendPci,
                                  const unsigned char *pbSendBuffer,
                                  uint32_t cbSendLength,
                                  CLPSCARD_IO_REQUEST pioRecvPci,
                                  unsigned char *pbRecvBuffer,
                                  uint32_t *pcbRecvLength);

C_PCSC_API int32_t CSCardListReaderGroups(SCARDCONTEXT hContext,
                                          char *mszGroups,
                                          uint32_t *pcchGroups);

C_PCSC_API int32_t CSCardListReaders(SCARDCONTEXT hContext,
                                     const char *mszGroups,
                                     char *mszReaders,
                                     uint32_t *pcchReaders);

C_PCSC_API int32_t CSCardCancel(SCARDCONTEXT hContext);

C_PCSC_API int32_t CSCardGetAttrib(SCARDHANDLE hCard,
                                   uint32_t dwAttrId,
                                   uint8_t *pbAttr,
                                   uint32_t *pcbAttrLen);

C_PCSC_API int32_t CSCardSetAttrib(SCARDHANDLE hCard,
                                   uint32_t dwAttrId,
                                   const uint8_t *pbAttr,
                                   uint32_t cbAttrLen);


#if defined(__cplusplus)
}
#endif

#endif
